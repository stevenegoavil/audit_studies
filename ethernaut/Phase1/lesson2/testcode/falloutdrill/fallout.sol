//SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

contract fallout {
    address public owner;
    uint public balance;

    function fal1out() public {
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "msg.sender is not owner");
        _;
    }
    function withdrawal() public onlyOwner{
        payable(owner).transfer(address(this).balance);
    }

}