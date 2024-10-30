// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {console} from "forge-std/Script.sol";

contract FunWithStorage {
    // Stored at slot 0
    bool someBool;

    // Stored at slot 1
    uint256 favoriteNumber;

    // Array Length Stored at slot 2, but the objects will be the keccak256(2),
    // since 2 is the storage slot of the array
    uint256[] myArray;

    // An empty slot is held at slot 3
    // and the elements will be stored at keccak256(h(k) . p)
    // p: The storage slot (aka, 3)
    // k: The key in hex
    // h: Some function based on the type. For uint256, it just pads the hex
    mapping(uint256 => bool) myMap;

    uint256 constant NOT_IN_STORAGE = 123;
    uint256 immutable i_not_in_storage;

    // Array Length Stored at slot 4, but the objects will be the keccak256(4),
    // since 4 is the storage slot of the array
    uint8[] public myArray2;

    constructor() {
        someBool = true; // See stored spot above // SSTORE
        favoriteNumber = 25; // See stored spot above // SSTORE
        myArray.push(222); // SSTORE
        myMap[0] = true; // SSTORE
        i_not_in_storage = 123;
    }

    function doStuff() public view {
        uint256 newVar = favoriteNumber + 1; // SLOAD
        bool otherVar = someBool; // SLOAD
        // ^^ memory / stack variables
    }

    function doStuff2() public {
        // Default to 0 if the array is empty, so index 0 = 0
        // uint8 can only hold values between 0 and 255
        uint8 newVar = 0; //SLOAD

        if (myArray2.length > 0) {
            newVar = myArray2[myArray2.length - 1] + 1;
            require(newVar <= 255, "No more than 255 elements in myArray2");
        }
        console.log("New var is", newVar);

        myArray2.push(newVar); // SSTORE
    }
}
