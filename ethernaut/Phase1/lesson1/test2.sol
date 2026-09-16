// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0<0.9.0;

contract test {
    address public owner;
    mapping(address => uint256) public contributions;

    constructor(){
        owner = msg.sender;
        contributions[owner] > 1000 * 1 ether;
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "not the owner");
        _;
    }
    function contribute() public payable{
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if(contributions[msg.sender] > contributions[owner]){
            owner = msg.sender;
        }
        
    }

    function withdraw() public payable onlyOwner(){
        require(msg.value > 0);
        payable(owner).transfer(address.(this).balance);
    }
    receive() public payable {
        require(contributions[msg.sender]>0 && msg.value > 0);
        owner = msg.sender;

    }


}