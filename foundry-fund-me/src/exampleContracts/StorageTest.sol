// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract StorageTest {
    // https://x.com/silen7_pool/status/1851637048064491626

    // myArray.length is stored at slot 0
    // while values are stored starting at slot keccak256(0)
    uint256[] private myArray;

    // myArray2.length is stored at slot 1
    // while values are stored starting at slot keccak256(1)
    uint256[] private myArray2;

    constructor() {
        myArray.push(7);
    }

    // Pushes a value to myArray
    function pushToMyArray(uint256 value) public {
        myArray.push(value);
    }

    // Pushes a value to myArray2
    function pushToMyArray2(uint256 value) public {
        myArray2.push(value);
    }

    // Returns an element of myArray by index
    function getMyArray(uint256 index) public view returns (uint256) {
        require(index < myArray.length, "Index out of bounds");
        return myArray[index];
    }

    // Returns an element of myArray2 by index
    function getMyArray2(uint256 index) public view returns (uint256) {
        require(index < myArray2.length, "Index out of bounds");
        return myArray2[index];
    }
}
