// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.8.0;

contract simplebuying {
    address public owner;
    uint public balance;

    constructor () {
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "not owner");
        _;
    }

    function deposit() public payable{
        balance += msg.value;
    }

    function withdraw() public onlyOwner{
        payable(owner).transfer(balance);
        balance = 0;
    }
    

}