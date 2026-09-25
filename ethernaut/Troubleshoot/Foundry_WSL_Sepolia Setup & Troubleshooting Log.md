# Foundry / WSL / Sepolia — Setup & Troubleshooting Log
# UPDATED - 9/25/2026 
Full record of getting Foundry working from a fresh Windows machine, plus every real issue hit and how it was fixed. Read top to bottom for setup; jump to "Issues Hit" for specific problems.

---

## Setup — From Zero

### 1. Install WSL (Windows Subsystem for Linux)
Why: Foundry's installer and tools (`forge`, `cast`, `anvil`) are Unix-native. PowerShell can't run `curl -L ... | bash` — no `bash`, no Unix-style `curl`. WSL gives you a real Ubuntu Linux environment inside Windows.

```powershell
wsl --install
```
Reboot when prompted. Then open the **Ubuntu** app from Start menu (not PowerShell) — first launch asks you to set a Linux username/password (can differ from Windows login).

### 2. Install Foundry (inside the Ubuntu/WSL terminal, not PowerShell)
```bash
curl -L https://foundry.paradigm.xyz | bash
```
It'll tell you to add it to PATH:
```bash
export PATH="$PATH:/home/YOUR_USERNAME/.foundry/bin"
foundryup
```
Make the PATH change permanent (otherwise it resets every new terminal session):
```bash
echo 'export PATH="$PATH:/home/YOUR_USERNAME/.foundry/bin"' >> ~/.bashrc
```

### 3. Create the project
```bash
cd ~
mkdir ethernaut-attacks && cd ethernaut-attacks
forge init
```
This creates `src/`, `script/`, `test/`, `lib/`, `foundry.toml`.

Note: putting the project under `~` (Linux-native) is faster than `/mnt/c/...` (Windows-mounted), but means VSCodium's normal Windows file picker can't browse to it — only VS Code with WSL Remote can open it directly (see below).

### 4. Editor: VS Code + WSL Remote
- VSCodium **cannot** do this — Microsoft's Remote-WSL extension is proprietary, blocked from VSCodium's marketplace (Open VSX). Sideloading it manually is unsupported/unreliable — not worth the detour.
- Real VS Code has Remote-WSL built in. From the WSL terminal, inside your project folder:
```bash
code .
```
First time, a dialog may ask to allow host `wsl.localhost` — check "Permanently allow" and click Allow.
- Confirm it worked: bottom-left corner of VS Code should show a green **"WSL: Ubuntu"** indicator.

### 5. Alchemy account + Sepolia RPC URL
- Sign up free at alchemy.com.
- Create a new app: **Chain = Ethereum, Network = Ethereum Sepolia** (not Mainnet — see Issues Hit #5 below, this exact mistake cost real debugging time).
- Copy the app's HTTPS URL (looks like `https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY`).
- Set it in terminal (type directly, never paste secrets into chat/AI tools):
```bash
export SEPOLIA_RPC_URL="https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY"
```

### 6. Wallet + Sepolia test ETH
- Use a dedicated test wallet, not one holding real funds.
- Get free Sepolia ETH from a faucet (e.g. Alchemy's own Sepolia faucet).
- Export the private key from MetaMask (⋮ menu → Account details → Show private key). Set it directly in terminal:
```bash
export PRIVATE_KEY="your_key_here"
```
- **Never paste this into chat, a script committed to git, or anywhere outside the terminal.** If exposed, treat the wallet as compromised — move funds out, generate a new one.

### 7. Verify environment before doing anything else (see Issue #5 — do this every session)
```bash
cast chain-id --rpc-url "$SEPOLIA_RPC_URL"
```
Must return `11155111` (Sepolia). If it returns `1`, you're pointed at Mainnet — stop and fix the Alchemy app's network before deploying or sending anything.

---

## Standard Workflow (once set up)

1. Write/edit contract in `src/` via VS Code (WSL-connected).
2. `forge build` — compile, fix any errors.
3. Confirm env vars are set this session: `export SEPOLIA_RPC_URL=...` / `export PRIVATE_KEY=...` (only needed once per terminal session unless made permanent via `~/.bashrc`).
4. **Verify network**: `cast chain-id --rpc-url "$SEPOLIA_RPC_URL"` → must be `11155111`.
5. Get target address from Ethernaut console: `await contract.address`.
6. Deploy:
```bash
forge create src/YourFile.sol:ContractName --rpc-url "$SEPOLIA_RPC_URL" --private-key "$PRIVATE_KEY" --broadcast --constructor-args 0xTargetAddress
```
7. **Save the deployed address somewhere durable** — not just scrollback (see Issue #6).
8. Call functions:
```bash
cast send DEPLOYED_ADDRESS "functionName()" --rpc-url "$SEPOLIA_RPC_URL" --private-key "$PRIVATE_KEY"
```
9. Verify state changed, independently:
```bash
cast call TARGET_ADDRESS "someView()(returnType)" --rpc-url "$SEPOLIA_RPC_URL"
```
10. Cross-check on `sepolia.etherscan.io` with the address or tx hash.

---

## Issues Hit (real, tonight, in order)

### 1. `curl -L ... | bash` fails in PowerShell
**Symptom:** `Invoke-WebRequest : A parameter cannot be found that matches parameter name 'L'` / `bash not recognized`.
**Cause:** PowerShell isn't bash; `curl` is aliased to `Invoke-WebRequest`, doesn't support `-L` the same way, and there's no `bash` binary.
**Fix:** Run inside WSL Ubuntu terminal instead, not PowerShell.

### 2. `forge create` — "Constructor argument count mismatch: expected 1 but got 2"
**Symptom:** Happened when `--constructor-args` was placed as the *last* flag, followed by nothing (should've been fine) but errored anyway.
**Cause:** This Foundry version's flag parser seems to treat `--constructor-args` as greedily consuming trailing tokens; placing another flag after it caused misparsing.
**Fix:** Put `--broadcast` (and any other flags) *before* `--constructor-args`, so nothing follows the address:
```bash
forge create src/X.sol:Y --rpc-url "$URL" --private-key "$KEY" --broadcast --constructor-args 0xAddress
```

### 3. Multi-line commands with `\` continuation breaking
**Symptom:** `error: unexpected argument ' --rpc-url' found` — happened when pasting a command split across lines with trailing backslashes.
**Cause:** Copy-pasting multi-line backslash-continued commands into some terminals doesn't preserve the continuation correctly, especially from certain sources/clipboard formats.
**Fix:** Just write the whole command on one line. Terminal will visually wrap it, that's fine — avoids the issue entirely.

### 4. `cast call` / `cast code` returning "does not have any code" for an address that Etherscan confirms is real
**Symptom:** Genuinely confusing — Etherscan showed the contract existed with real transaction history, but `cast code`/`cast call` against the same address via Alchemy said no code.
**Cause:** Turned out to be Issue #5 (wrong network) — the RPC endpoint was silently querying Mainnet, where that specific address (coincidentally a valid-looking address) had no code, while the *real* contract existed on Sepolia.
**Fix:** See #5.

### 5. **Root cause of the above: Alchemy app was set to Ethereum Mainnet, not Sepolia**
**Symptom:** `cast block-number --rpc-url "$SEPOLIA_RPC_URL"` returned a huge number (~26 million) matching Mainnet's real height, while Etherscan (correctly showing Sepolia) was around ~11.78 million. Browser-side `web3.eth.net.getId()` in Ethernaut's console correctly showed `11155111` (Sepolia) because that check goes through MetaMask's connection, not the Alchemy endpoint used in the terminal — two completely separate connections, easy to assume they're the same, they're not.
**Fix:** Alchemy apps' network generally can't be changed after creation — create a **new** Alchemy app explicitly set to Chain: Ethereum, Network: Ethereum Sepolia. Update `SEPOLIA_RPC_URL` to the new app's URL. **Always verify with `cast chain-id` (must return `11155111`) before deploying or sending anything** — make this the first command of every session, not a debugging afterthought.

### 6. Calling `hack()` on a stale/old deployed contract address instead of the current one
**Symptom:** Transaction succeeded (`status 1`), but the target contract's `owner()` still showed the wrong address — exploit appeared to run but didn't actually change anything.
**Cause:** Multiple `Attack` contracts had been deployed across the session (fresh Ethernaut instance restarts, wrong-network redeploys). Copy-pasted an address from earlier scrollback that was no longer the current deployment.
**Fix:** No single command fixes this — it's a bookkeeping problem. Track deployed addresses deliberately each session, e.g.:
```bash
echo "$(date): Telephone target=0x734628... attack=0x0CcEa3..." >> ~/ethernaut-attacks/deploys.log
```
Then reference `deploys.log` instead of scrollback when calling functions later.

### 7. Private key / API key exposure
**Symptom:** Both a `PRIVATE_KEY` and an Alchemy API key got pasted into a chat/log at least once each.
**Fix applied:** Treated as compromised — regenerated the Alchemy key, did not reuse the exposed wallet for anything beyond testnet.
**Standing rule:** Never paste a private key or API key anywhere outside a terminal `export` command. If it happens anyway, rotate/regenerate immediately — testnet-only wallets make this low-stakes, but the habit is what matters, since the same key format is used for real funds too.

---

## Quick Reference — Safe Checks (no gas, no risk)

```bash
cast chain-id --rpc-url "$SEPOLIA_RPC_URL"                      # must be 11155111
cast block-number --rpc-url "$SEPOLIA_RPC_URL"                  # sanity check vs etherscan
cast code ADDRESS --rpc-url "$SEPOLIA_RPC_URL"                  # 0x = no contract there
cast balance YOUR_WALLET --rpc-url "$SEPOLIA_RPC_URL" --ether   # check test ETH balance
cast call TARGET "fn()(returnType)" --rpc-url "$SEPOLIA_RPC_URL" # read-only, free
```