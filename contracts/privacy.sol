// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {

    bool public locked = true;  //slot 0
    uint256 public ID = block.timestamp; //slot 1
    uint8 private flattening = 10; //slot 2 : 8 bit
    uint8 private denomination = 255; //slot 2 : 16 bit
    uint16 private awkwardness = uint16(block.timestamp); //slot 2 : 32 bit
    bytes32[3] private data; // slot 3,4,5

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function upnlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
      A bunch of super advanced solidity algorithms...

        ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
        .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
        *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
        `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
        ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}

contract Test_Casting {
    uint256 public a = 0x123456789;// 0
    uint128 public b1 = uint16(a);// 1
    uint128 public b2 = uint8(a);// 1
    bytes16 public c1 = "123456789"; // 2
    bytes16 public c2 = "abcdef";// 2
    bytes32 public d1 = bytes8(c1); // 3
    bytes32 public d2 = bytes32(c1); // 4
    bytes8 public e = "abcdef"; //5
    uint16 public e1 = uint16(uint64(e));
    uint32 public e2 = uint32(uint64(e));
    uint64 public e3 = uint64(e);
//  web3.eth.get_storage_at(t.address, f"0x{1:064x}").hex() : 0x0000000000000000000000000000008900000000000000000000000000006789
// web3.eth.get_storage_at(t.address, f"0x{2:064x}").decode() : abcdef\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00123456789\x00\x00\x00\x00\x00\x00\x00
}


//P_ADDRESS = "0x1ff6e9b1e3136E39c30755f0E866EEF95E09CEF5"
//s5_addr = f"0x{5:064x}"
//s5_value = web3.eth.get_storage_at(P_ADDRESS, s5_addr).hex() 0x939153f66ad5c32c98a609216a393fc2c3bd49d23d077aca92828c0b34565b32
//s5_16bytes = s5_value[:-32]
//s5_bytes = bytes.fromhex(s5_16bytes[2:]) // s5_value = s5_bytes.hex()
//contract.locked(s5_bytes, {"from":accounts[0]})