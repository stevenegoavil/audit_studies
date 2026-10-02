//SPDX-License-Identifier: unlicense
pragma solidity 0.8.0;

//patch code for function to work as desired
//want change owner to do the following:
//msg.sender cannot have original address of contract caller and cant be the last person who called function

//try modification for cantbeowner
address public lastowner;
address public currentowner;

modifier notlastowner(){
    require(msg.sender != lastowner, "this person was owner of the last contract");
    _;
}
modifer onlywallet(){
    require(tx.origin == owner, "only wallets can call this contract");
}
function changeOwner(address _newowner) public notlastowner onlywallet {
            if (tx.origin != msg.sender) {
            owner = _newowner;
        } // could keep this part also as extra security
}

// this is a triple protection without changing much of the current code and is the true intension of the code

// this is incorrect
//simple fix is needed, do not use tx.origin for secuirty purposes

modifier onlyowner(){
    require(msg.sender == owner, "person accessing contract needs to be owner");
    _;
}// this fixes the whole phising issue in telephone contract and is standard practice