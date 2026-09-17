# Balance vs address(this).balance — Concept Check
Date: 9/16/2026

## Context
Real distinction found while drilling the Fallout withdrawal pattern: a
declared `uint public balance` variable is NOT automatically the same as
the contract's actual ETH holdings. `address(this).balance` is a built-in,
live, real-time property every address has — it doesn't need to be declared
or manually tracked.

## Questions

### Conceptual
1. What's the difference between `address(this).balance` and a variable
   like `uint public balance`?
2. If you declare `uint public balance;` but never update it anywhere in
   your contract, what value will it always show? Why?
3. Why does `address(this)` refer to the contract, and not to whoever is
   calling the function?
4. If two people both deposit ETH into a contract, does
   `address(this).balance` reflect the total from both, or just one
   person's deposit?

### Code Prediction
5. If a contract has 5 ETH in it and you write
   `payable(owner).call{value: address(this).balance}("")`, how much ETH
   gets sent?
6. What happens if you write `payable(owner).call{value: balance}("")`
   where `balance` is a `uint` you declared but never updated — what
   actually gets sent?

### Debugging
7. Here's a broken contract — why does calling `withdrawal()` send 0 ETH
   even though the contract clearly holds funds?
```solidity
   uint public balance;
   function withdrawal() public onlyOwner {
       payable(owner).call{value: balance}("");
   }
```
8. Someone writes this thinking it tracks the contract's funds
   automatically — explain why it doesn't:
```solidity
   uint public balance = address(this).balance;
```
   (Hint: this only runs once — when?)

### Mastery Check
9. Design a contract where you WANT to track `balance` as a separate
   variable that updates every time someone deposits — write the
   `deposit()` function that keeps it accurate, and explain why you'd
   ever want this instead of just using `address(this).balance` directly.