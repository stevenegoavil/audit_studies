//SPDX-License-Identifier:MIT;
pragma solidity >=0.4.0<0.9.0;

contract charity2 {
    address public owner;

    constructor(uint256, _goalAmount) {
        owner = msg.sender;
        goalAmount = _goalAmount;
    }
}
//second attempt
