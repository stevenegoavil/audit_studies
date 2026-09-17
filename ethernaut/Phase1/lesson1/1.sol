//SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

contract one {
    address public owner;
    mapping(address => uint256) public contributions;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "msg.sender is not owner");
        _;
    }
    
    



}
