//first attempt 10:40AM
//SPDX-License-Identifier:MIT
pragma solidity^0.9.0;

contract charity {
address public owner;
uint256 public goalAmount;

    contructor(){
        owner = msg.sender;
        goalAmount = _goalAmount;
    }

}
// issues with this code - 
// constructor is spelled incorrectly 
// _goalAmount isnt anywhere in the library contract

