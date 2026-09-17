## Prompt: Fallout — write this contract from scratch, blind, no autocomplete

Your contract must include all four of these pieces:

1. State variables:  
-> `address public owner`  
-> `uint public balance`
2. A constructor-like function with a typo in its name (so it does NOT run automatically — it stays a regular callable public function instead). Name it something close to "constructor" but misspelled, same as the real Ethernaut level.
3. A modifier called onlyOwner that restricts access to only the address stored in owner, using require.
4. A withdrawal function that:  
-> Is public  
-> Uses the onlyOwner modifier  
-> Sends the contract's ETH balance to owner

"Write all four pieces. Don't skip the modifier — it's the actual point of this exercise. If you get stuck on any single line, write a plain English comment describing what you're trying to do there and keep moving to the next piece."