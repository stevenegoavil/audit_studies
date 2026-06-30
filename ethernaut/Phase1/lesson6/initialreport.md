# initial report -
>just a once read using all the tools available to me
---

## level 6 - Delegate
>The goal of this level is for you to claim ownership of the instance you are given.

>  Things that might help

>Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
>Fallback methods
>Method ids

first read through - Looking like the solidity 0.8.0 is significate secuirty protocall - we are trying to make ourselves owner 

appears to be two contracts on one block call - I believe this to be a secuirty issue and perhaps a bad use of wei-  but let us continue

constructor appears to be fine, function is being used instead modification for authorization msg.sender

In the contract delegation, first part is a bit confusing it just says Delegte delegate. 

Ok, after reading the whole contract, I see what is happening. And i beleive to know what best practice to fix this but also I see the issue.

First it appears the user is trying to make a multicontract trigger - one for authorized users and the other seems to be bool external message caller, I beleive the contract owner wants to be the only one who can access the delegation contract, and the fallback trigger seems to be perhaps another code that will be triggered outside this delgate contract

They are trying to make multi level secuirty functions on 1 contract which in itself not a good idea, not sure if this is true but first of all as we know code isnt called in order but in speed of how fast the function calls- so this could come back as error, but if youre trying to break in - you could run function pwn() after running the - dead end

