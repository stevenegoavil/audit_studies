# Solidity Patterns & Vulnerability Reference - UPDATED 9/25/2026

Living document — update briefly after each Ethernaut level with anything genuinely new. Not a full rewrite each time; just add what's new, fix what was wrong.

---

## Syntax Patterns

### 1. State variable declaration
```solidity
<type> <visibility?> <name> = <value>;
```
```solidity
uint256 public total = 0;
address target;
```

### 2. Constructor
```solidity
constructor(<params>) {
    <body>
}
```
```solidity
constructor(address _target) {
    target = _target;
}
```
⚠️ Old Solidity (pre-0.4.22) used a function named identically to the contract as the constructor instead of the `constructor` keyword. If the contract gets renamed and that function doesn't, it silently becomes a regular public function — callable by anyone, anytime. (See Fallout / Rubixi below.)

### 3. Function definition
```solidity
function <name>(<params>) <visibility> <modifiers?> returns (<type>) {
    <body>
}
```
```solidity
function flip(bool _guess) public returns (bool) {
    return _guess;
}
```

### 4. Calling another contract — typed (high-level)
Requires the target contract's full source visible in-file (or imported). Compiler checks the call at compile time.
```solidity
CoinFlip public target;

constructor(address _targetAddress) {
    target = CoinFlip(_targetAddress);
}

function hack() public {
    target.flip(true);
}
```

### 5. Calling another contract — low-level
No source needed; `target` is just a plain `address`. No compile-time safety — a typo'd signature fails silently at runtime, not compile time. `success` must be checked manually.
```solidity
(bool success,) = target.call(
    abi.encodeWithSignature("flip(bool)", side)
);
require(success);
```
Rules:
- Only the signature string itself gets quotes (`"flip(bool)"`) — arguments after it are never quoted, regardless of type.
- No-arg functions: no trailing comma or empty string — just `abi.encodeWithSignature("reset()")`.
- Always `abi.encodeWithSignature` — the dot is easy to drop by habit.

### Common personal error patterns (mine, worth double-checking for)
- Declaration order: `<type> <visibility> <name>`, not the reverse.
- Missing `public` when the prompt asks for it — re-read for that word specifically.
- Missing semicolons on `return` statements.
- Confusing "define a function" (Section C-style) vs. "call a function that already exists" (Section D-style, just `target.fn(args);`, no `function` keyword).
- Direction of data: argument going *in* to a call vs. return value coming *out* — e.g. `bool result = target.isActive();` not `target.isActive(bool result)`.
- Type vs. variable mixup — calling on the actual object (`pool.borrow(...)`), not its type (`uint256.borrow(...)`).

---

## Vulnerability Classes

### Level 3 — CoinFlip: Weak / Predictable Randomness
**Mechanism:** `blockhash(block.number - 1)`, `block.timestamp`, `block.difficulty`/`block.prevrandao` are all public, deterministic chain data — not random. Blockchains require deterministic execution for consensus (every node must compute the same result), so no on-chain data source can ever be truly unpredictable. An attacker contract computes the same value independently, in the same transaction/block, and submits it as a "guess" that's actually a pre-known answer.
**Fix:** Chainlink VRF (off-chain generation + on-chain cryptographic proof of fairness) or commit-reveal (split across transactions so no single tx can compute everything in advance). Hashing multiple block-derived values together (`keccak256(block.timestamp, blockhash(...), ...)`) does NOT fix this — it just obscures the predictability, doesn't remove it.
**Real-world match:** Code4rena NextGen contest (Oct 2023), Issue #407, "Bad sources of randomness" — Medium severity. Same root mechanism, cross-references a matching Holograph contest finding — confirms this is a recurring, common bug class.

### Level 2 — Fallout: Misnamed Constructor (old Solidity pattern)
**Mechanism:** Pre-0.4.22 Solidity used a function matching the contract's name as the constructor. If the contract gets renamed later and that function isn't renamed to match, it silently stops being a constructor and becomes a normal public function — callable by anyone, anytime after deployment, not just once at deploy time.
**Real-world match:** Rubixi (2016) — originally named `DynamicPyramid`, renamed to `Rubixi`, but the constructor-named function wasn't updated. Anyone could call it post-deployment and reassign themselves as owner, redirecting fees.

---

## Deployment / Foundry Workflow Lessons

- **Always verify RPC network before doing anything, every session:** `cast chain-id --rpc-url "$SEPOLIA_RPC_URL"` must return `11155111`. An Alchemy app accidentally set to Mainnet instead of Sepolia will silently accept commands and return believable-looking (but wrong-network) results — `cast code`/`cast call` against a real contract will say "does not have any code" because it's checking the wrong chain. Browser-side checks (`web3.eth.net.getId()` in Ethernaut's console) only confirm MetaMask's connection, NOT the terminal's Alchemy endpoint — they're separate connections and can disagree.
- **Track deployed addresses deliberately, don't rely on scrollback.** Across a session with multiple redeploys (fresh Ethernaut instances, wrong-network retries), it's easy to `cast send hack()` against a stale, no-longer-relevant `Attack` contract address copy-pasted from earlier in the terminal. The transaction will still report `status 1 (success)` even though it didn't do anything meaningful, because the call itself succeeded — it just wasn't targeting the current deployment. Log every deploy: `echo "$(date): Level=X target=0x... attack=0x..." >> deploys.log`.
- **`forge create` flag order matters:** put `--broadcast` before `--constructor-args`, not after — this specific Foundry version mis-parses when a flag follows `--constructor-args`.
- **Type multi-line commands as one line.** Backslash line-continuations pasted into the terminal have caused real parsing errors more than once — not worth the risk for a cosmetic formatting choice.
- Full troubleshooting log: see `troubleshoot.md`.

## Tooling Notes
- **Slither** — static analyzer; would auto-flag `blockhash`/`block.timestamp` used as a randomness source. Not yet set up — next tool to learn.
- **Foundry** (`forge`, `cast`, `anvil`) — Linux/WSL-native, terminal-first. Still building fluency vs. Hardhat/Remix's UI.
- **Solodit checklist SOL-AM-MA-2** — "Is the contract using block properties like timestamp or difficulty for randomness generation?"