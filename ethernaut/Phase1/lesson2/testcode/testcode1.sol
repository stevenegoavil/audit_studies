//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
//if you dont write correctly it wont populate solidity version - pragma was spelling correctly
import "whatever the import is ";

contract Fallout {
address public owner;
uint public balance;

function fal1out {
    owner = msg.sender;
}
// fix constructor{
// owner=msg.sender ;
// }

modifier onlyOwner(){
    require(msg.sender == owner, "caller is not the owner");
    _;
}

function withdrawal public payable onlyOwner{
    
}
}
