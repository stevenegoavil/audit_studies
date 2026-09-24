## Level 3 — CoinFlip

**Bug Class:** Weak/Predictable Randomness
**Severity:** High (in production) / Trivial (this instance) (Impact: full, guaranteed exploitation of any value-bearing randomness | Likelihood: trivial to trigger)
**Solodit Tags:** didnt use tag this time - I just searched the web for blockhash vunerabilities and found a bunch of 2023 randomness vunerabilities on github
This time was a github find!

---

### The Vulnerability
CoinFlip.flip(bool _guess) requires the caller to submit a guess for a coin-flip outcome, computed internally from blockhash(block.number - 1). This value is treated by the contract as unpredictable, but it is actually public, deterministic chain data — readable by anyone, including another smart contract, before the call is even made. Because Solidity execution must be deterministic (every node has to independently compute the same result for network consensus), there is no source of true on-chain randomness; any value derived purely from block data can be computed in advance by an attacker's own contract.

``` uint256 blockValue = uint256(blockhash(block.number - 1));
uint256 coinFlip = blockValue / FACTOR;
bool side = coinFlip == 1 ? true : false;
```
---

### The Exploit

An attacker contract performs the identical calculation shown above, inside a single function, then immediately calls flip() with the pre-computed correct answer — all within the same transaction/block. This guarantees the value the attacker reads matches what CoinFlip reads a moment later, since both are reading the exact same already-mined block. This isn't guessing; it's independently deriving the same public value first, then submitting it as if it were a guess.

// step 1 - write Attack contract
// step 2 - deploy Attack contract on Sepolia testnet, pointed at the existing CoinFlip instance
// step 3 - call hack() on the Attack contract once per block, 10 times total
// step 4 (optional) - verify on-chain via block explorer / cast call that consecutiveWins == 10

**Why this works:** 

flip() never volunteers the answer — it demands the caller commit to a guess first, then only tells you pass/fail. The vulnerability isn't that flip() leaks information; it's that the "secret" it checks the guess against is actually public, deterministic data the attacker can compute independently, in advance, using the exact same formula.

This is a structural property of blockchains, not a fixable flaw in this contract alone: every node must deterministically compute the same result for consensus to work, so no on-chain data source (block number, blockhash, timestamp) can ever be truly unpredictable. Real randomness must come from off-chain (Chainlink VRF) or be split across multiple transactions (commit-reveal).
---

### The Fix

Replace on-chain blockhash-derived randomness with Chainlink VRF: an oracle generates the random value off-chain and delivers it in a separate transaction along with a cryptographic proof of fairness. The contract verifies that proof on-chain before accepting the value, so no single party — including the oracle itself — can bias or predict the outcome. This also correctly splits the flow across two transactions (request, then fulfillment), so no single transaction can compute everything in advance.

```// patched code (conceptual shape, not full implementation)
// 1. requestRandomness() - calls Chainlink VRF Coordinator, stores a request ID
// 2. fulfillRandomWords(requestId, randomWords) - VRF Coordinator callback,
//    delivers the verified random value in a LATER transaction
// 3. Game logic only resolves once fulfillRandomWords has been called —
//    never derives the outcome from block.* data
```

**Why this fix is correct:** the random value doesn't exist yet at the moment the player commits their guess, and its authenticity is cryptographically provable rather than trusted — removing both the predictability problem and the "just trust the backend" problem a naive off-chain-only fix would introduce.

---

### Severity Reasoning

- **Impact:** Attacker gains guaranteed, predictable control over every coin flip outcome — able to win 100% of the time instead of the intended 50%. In a real system with value attached, this means complete extraction of funds/prizes and total loss of trust in the game's fairness.
- **Likelihood:** Trivial to trigger — requires only basic understanding of blockhash/block.number and how to write a simple attacking contract. No special access, no race condition, no timing window needed.
- **Rating:** 
  - This instance: Trivial — no monetary value at stake, purely educational.
  - Production equivalent: Critical/High — this exact mechanism, applied to gambling, lotteries, NFT mint rarity, or loot box systems, would allow guaranteed, repeatable exploitation of real value.

---

### Github Match

"Bad sources of randomness" — Code4rena, NextGen contest, Oct 2023, Issue 407. Severity: Medium. calculateTokenHash() derives a token hash using blockhash(block.number - 1) combined with other block-derived "random" values (block.prevrandao, block.timestamp) via keccak256. Same root mechanism as CoinFlip — hashing multiple predictable block values together doesn't add real entropy, it just obscures the predictability. Finding also notes an unused _saltfun_o parameter that was clearly intended to add salt but was never wired in. Cross-references a matching finding in a separate contest (Holograph), confirming this is a recurring, common bug class, not a one-off.

---

### What I'd Do Differently

- **Tool check:** A static analyzer like Slither would flag blockhash/block.timestamp usage as a randomness source automatically — worth adding Slither to the toolbelt once past the current Foundry ramp-up.
- **Pattern generalization:** Any on-chain value derived from block.number, blockhash, block.timestamp, or block.difficulty used for a security-critical decision (randomness, access control, timing) is exploitable by anyone who can read or compute that same public data. Shows up in lotteries, NFT mint randomization, loot boxes, PvP matchmaking.
- **Missed on first read:** Initially conflated function visibility (public) with data visibility — assumed the risk was "anyone can call this function" rather than "the data it relies on is public and predictable." Also initially misunderstood the lastHash == blockValue check as being the source of the vulnerability, when it's actually just an unrelated same-block replay guard.

---

### Personal Gaps

Still shaky on the Foundry/bash workflow — coming from Hardhat and Remix's UI, the terminal-first setup (WSL, environment variables, forge/cast syntax) didn't click easily. Plan is repetition, not detouring into more tooling, until it's automatic. On CoinFlip's actual logic, I understand the mechanism now — low-level vs. high-level calls, why deterministic consensus rules out on-chain randomness — but I got there through a lot of guided correction, not by reasoning it out cold. That gap between "can explain it" and "can derive it independently" is what I'm still closing. I also don't know audit tooling at all yet — had to look up what Slither even is — and I don't have the block.* vocabulary (blockhash, block.timestamp, block.difficulty) memorized; I recognize them when I see them explained, not on my own.