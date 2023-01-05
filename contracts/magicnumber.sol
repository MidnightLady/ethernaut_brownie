// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {

    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
      ____________/\\\_______/\\\\\\\\\_____
       __________/\\\\\_____/\\\///////\\\___
        ________/\\\/\\\____\///______\//\\\__
         ______/\\\/\/\\\______________/\\\/___
          ____/\\\/__\/\\\___________/\\\//_____
           __/\\\\\\\\\\\\\\\\_____/\\\//________
            _\///////////\\\//____/\\\/___________
             ___________\/\\\_____/\\\\\\\\\\\\\\\_
              ___________\///_____\///////////////__
    */
}

contract CreateSolver {
    address public addr;

    // Deploys a contract that always returns 42
    function create() external returns (address){
        // 600a600c600039600a6000f3602a6000526001601ff3

        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address _addr;
        assembly {
            // create(value, offset, size)
            _addr := create(0, add(bytecode, 0x20), 0x13)
        }
        require(_addr != address(0));
        addr = _addr;
        return addr;
    }
}

