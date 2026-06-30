// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.0 < 0.8.0;

// License - Identifier is important

contract simplybuying2 {
    address public owner;
    uint public balance;

    constructor () {
        owner = msg.sender;
    }

    // when it comes to the modifier remeber it has to have a function name to be called upon
    modifier onlyOwner() {
        require(owner == msg.sender, "Not the owner");
        _; // answer - run the function after this call - claude
    } // not sure what the _; is for?
}