//3rd attempt 9/16/26 10:44AM
//SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;

contract charity3 {
    address public owner;
    uint public goalAmount;

    constructor (uint256 _goalAmount) {
        owner = msg.sender;
        goalAmount = _goalAmount;
    } //I think i get it, we defined _goalAmount in the constructor - it does feel redundent though since goalAmount is already a uint
}// perhaps we are making all goalAmount into _goalAmount because when the contract function is called it keeps its same uint and cant be misconstruded ?
