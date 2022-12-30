// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Recovery {

    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);

    }
}

contract SimpleToken {

    string public name;
    mapping(address => uint) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // allow transfers of tokens
    function transfer(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}

contract Atk_Recovery {
    function contract_address_generator(address addr, uint nonce) public view returns (address) {
        if (nonce == 0x00)
            return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), addr, bytes1(0x80))))));
        if (nonce <= 0x7f)
            return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), addr, bytes1(uint8(nonce)))))));
        if (nonce <= 0xff)
            return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd7), bytes1(0x94), addr, bytes1(0x81), uint8(nonce))))));
        if (nonce <= 0xffff)
            return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd8), bytes1(0x94), addr, bytes1(0x82), uint16(nonce))))));
        if (nonce <= 0xffffff)
            return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd9), bytes1(0x94), addr, bytes1(0x83), uint24(nonce))))));

        return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xda), bytes1(0x94), addr, bytes1(0x84), uint32(nonce))))));

    }
}