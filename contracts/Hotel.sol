// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Hotel {
    uint public constant maxRooms = 20;
    uint public roomsAvailable = maxRooms;
    address payable owner = payable(0xCe1294dA9895F6754852EdE1B519a51F77a3B18F);

    mapping(address => bool) hasBooking;

    modifier roomsAvailableCheck() {
        require(roomsAvailable > 0, "All rooms are occupied");
        _;
    }

    function book() public payable roomsAvailableCheck {
        require(!hasBooking[msg.sender], "You've already booked a room");
        (bool success, ) = owner.call{value: msg.value}("");
        require(success, "Transfer failed");
        hasBooking[msg.sender] = true;
        roomsAvailable--;
    }

    function room() public view returns (uint) {
        return roomsAvailable;
    }

    function hasBooked() public view returns (bool) {
        return hasBooking[msg.sender];
    }

    function checkOut() public roomsAvailableCheck {
        require(hasBooking[msg.sender], "You don't have any booking");
        roomsAvailable++;
        hasBooking[msg.sender] = false;
    }
}
