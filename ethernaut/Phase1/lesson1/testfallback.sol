// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.0 < 0.8.0;

contract testfallback {
    // forgot to writing mapping that says address will be a uint 256 bit named contribution
    address public owner;
    uint public balance;

    constructor() {
        owner = msg.sender;
        // did not write contributions in constructor - this is important because this
        // will tell you exactly how much contributions will be- not necesary for fallback method but makes things easier
    }
    //need modifier onlyOwner()
    // the point that fallback, is that you become owner by two entry points, let make it for the point of this test msg.sender

    function deposit() public payable{
        balance += msg.value;
        owner.balance == 0;
        owner = msg.sender; 

    } // this could be in lieu of gecontribution which is speific to how many ether will be transfered

    function checkbalance() external{
        owner.balance >= 0;
        owner = msg.sender;
    }

    function receive() payable external{

    }// need to learn to write receive functions - apparently they are their own functions and externally called is typical

}

// this shows that you can enter the contract via two ways which is hte fallback exploit
