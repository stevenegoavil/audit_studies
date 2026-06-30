# Audit Journal — Steven Egoavil
> One entry per Ethernaut level. Format: what the bug was, what I spotted before looking, what I would have missed, audit flag, matching Solodit finding.

---

## Level 1 — Fallback
**Date:** June 2026  
**Vulnerability:** Inconsistent access control — fallback function granted ownership with weaker requirements than `contribute()`  
**What I spotted before looking:** That more than one function could produce the same ownership outcome with different requirements  
**What I would have missed:** That you need to call `contribute()` first (to satisfy `contributions[msg.sender] > 0`) before sending ETH directly to trigger the fallback — the order of operations matters  
**Exploit:** Call `contribute()` with a small amount, then send ETH directly to the contract to trigger the fallback and claim ownership, then call `withdraw()`  
**Fix:** Apply consistent authorization checks across all entry points including `receive()` and `fallback()`. Use `onlyOwner` modifier.  
**Audit flag:** Any discrepancy in access control requirements between regular functions and fallback/receive functions  
**Solodit finding:** _TBD — search: access control_

---

## Level 2 — Fallout
**Date:** June 2026  
**Vulnerability:** Constructor naming bug — function named after contract (pre-0.5 pattern) became a public callable function due to a typo  
**What I spotted before looking:** That the function named `Fal1out` (with a 1, not l) was not the same as the contract name `Fallout` — making it a regular public function, not a constructor  
**What I would have missed:** How subtle the typo was — `Fal1out` vs `Fallout` — easy to miss in a real audit without careful character-by-character reading  
**Exploit:** Call `Fal1out()` directly at any time to claim ownership — no conditions required  
**Fix:** Always use the `constructor()` keyword. Never name a function after the contract.  
**Audit flag:** Any function named after the contract in pre-Solidity 0.5 code — cross-check function names character by character  
**Solodit finding:** _TBD — search: constructor_

---

## Level 3 — CoinFlip
**Date:** June 2026  
**Vulnerability:** Weak randomness — `blockhash(block.number - 1)` is public, deterministic, and readable by any contract in the same transaction  
**What I spotted before looking:** That `blockhash` and `block.number` are on-chain public values — not a secure source of randomness  
**What I would have missed:** That the attacker contract needs to compute the answer AND call `flip()` atomically in the same transaction — same block means same blockhash. Also needed 10 separate blocks, not 10 calls in one transaction.  
**Exploit:** Deploy attacker contract that reads the same `blockhash(block.number - 1)`, runs the same math, and calls `flip()` with the correct answer. Call `attack()` once per block, 10 times.  
**Fix:** Use Chainlink VRF for off-chain verifiable randomness. Never use block variables as an entropy source.  
**Audit flag:** Any use of `blockhash`, `block.number`, `block.timestamp`, or `block.difficulty` for randomness  
**Solodit finding:** _TBD — search: weak randomness_

---

## Level 4 — Telephone
**Date:** June 2026  
**Vulnerability:** `tx.origin` used for authorization instead of `msg.sender` — an intermediary contract splits the two values apart, satisfying the condition  
**What I spotted before looking:** That `tx.origin != msg.sender` would be satisfied if a contract called the function instead of a wallet directly  
**What I would have missed:** The distinction between who *deploys* the attacker contract vs who *calls* it — `msg.sender` inside `attack()` is the wallet calling it, not the contract itself. Important for passing the right address to `changeOwner()`.  
**Exploit:** Deploy attacker contract pointing at Telephone. Call `attack()` from your wallet — `tx.origin` = wallet, `msg.sender` = attacker contract, condition passes, ownership changes.  
**Fix:** Never use `tx.origin` for authorization. Always use `msg.sender`. Apply `onlyOwner` modifier with `msg.sender`.  
**Audit flag:** Any use of `tx.origin` for access control or ownership checks  
**Solodit finding:** _TBD — search: tx.origin_

---

## Level 5 — Token
**Date:** June 2026  
**Vulnerability:** Integer underflow — Solidity 0.6.0 has no built-in overflow/underflow protection. `uint256` wraps to `2^256 - 1` when subtracted below zero. The `require` check always passes because `uint256 >= 0` is always true by definition.  
**What I spotted before looking:** That the pragma was 0.6.0 — immediately flagged as missing arithmetic protection. The `require(balances[msg.sender] - _value >= 0)` check is useless on a uint256.  
**What I would have missed:** The economic implication — in a real token with DEX liquidity, wrapping to max uint256 would let an attacker dump infinite tokens and crash the price to zero (BEC Token 2018).  
**Exploit:** Call `transfer()` with `_value` greater than your balance — uint256 underflows to max value, giving effectively infinite tokens.  
**Fix:** Use Solidity 0.8.0+ (built-in revert on overflow/underflow) or import OpenZeppelin `SafeMath` on older versions.  
**Audit flag:** `pragma solidity` below `0.8.0` combined with any arithmetic operations (`+`, `-`, `*`) on uint values — check for SafeMath usage  
**Solodit finding:** _TBD — search: integer overflow_

---

## Syntax Patterns to Memorize

```solidity
// 1. Owner variable + constructor
address public owner;
constructor() {
    owner = msg.sender;
}

// 2. onlyOwner modifier
modifier onlyOwner() {
    require(msg.sender == owner, "not owner");
    _;
}

// 3. Calling another contract from attacker
(bool success,) = target.call(
    abi.encodeWithSignature("functionName(type)", argument)
);
require(success);
```

---

_Next: Level 6 — Delegation (delegatecall)_