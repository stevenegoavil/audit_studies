//SPDX-License-Identifer: MIT
pragma solidity >=0.4.0 <0.9.0;

contract withdrawaldrill {
    address public owner;
    uint public balance;
    modifier onlyOwner(){
        require(owner == msg.sender, "sender not owner");
        _;
    }
    function withdrawal() public onlyOwner{
        payable(owner).transfer(address(this).balance);
    }
}