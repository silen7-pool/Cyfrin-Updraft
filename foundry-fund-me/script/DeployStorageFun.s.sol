// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FunWithStorage} from "../src/exampleContracts/FunWithStorage.sol";

contract DeployFunWithStorage is Script {
    function run() external returns (FunWithStorage) {
        vm.startBroadcast();
        FunWithStorage funWithStorage = new FunWithStorage();
        vm.stopBroadcast();
        printStorageData(address(funWithStorage));
        printFirstMyArrayElement(address(funWithStorage));
        printFirstMyArray2Element(address(funWithStorage));
        getKeccak256_ofTwoWithEncode();
        getKeccak256_ofTwoWithEncodePacked();
        return (funWithStorage);
    }

    function printStorageData(address contractAddress) public view {
        for (uint256 i = 0; i < 10; i++) {
            bytes32 value = vm.load(contractAddress, bytes32(i));
            console.log("Value at location", i, ":");
            console.logBytes32(value);
        }
    }

    function printFirstMyArrayElement(address contractAddress) public view {
        bytes32 arrayStorageSlotLength = bytes32(uint256(2));
        bytes32 firstElementStorageSlot = keccak256(
            abi.encode(arrayStorageSlotLength)
        );
        bytes32 value = vm.load(contractAddress, firstElementStorageSlot);
        console.log("First element in myArray:");
        console.logBytes32(value);
    }

    function printFirstMyArray2Element(address contractAddress) public view {
        bytes32 arrayStorageSlotLength = bytes32(uint256(4));
        bytes32 firstElementStorageSlot = keccak256(
            abi.encode(arrayStorageSlotLength)
        );
        bytes32 value = vm.load(contractAddress, firstElementStorageSlot);
        console.log("First element in myArray2:");
        console.logBytes32(value);
    }

    function getKeccak256_ofTwoWithEncode() public pure {
        bytes32 getKeccak256_of2_withEncode = keccak256(abi.encode(2));
        console.log("getKeccak256_of2_withEncode");
        console.logBytes32(getKeccak256_of2_withEncode);
    }

    function getKeccak256_ofTwoWithEncodePacked() public pure {
        bytes32 getKeccak256_of2_withEncodePacked = keccak256(
            abi.encodePacked(uint256(2))
        );
        console.log("getKeccak256_of2_withEncodePacked");
        console.logBytes32(getKeccak256_of2_withEncodePacked);
    }

    // Option 1
    /*
     * cast storage ADDRESS
     */

    // Option 2
    // cast k 0x0000000000000000000000000000000000000000000000000000000000000002
    // cast storage ADDRESS <OUTPUT_OF_ABOVE>

    // Option 3:
    /*
     * curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"debug_traceTransaction","params":["0xe98bc0fd715a075b83acbbfd72b4df8bb62633daf1768e9823896bfae4758906"],"id":1}' http://127.0.0.1:8545 > debug_tx.json
     * Go through the JSON and find the storage slot you want
     */

    // You could also replay every transaction and track the `SSTORE` opcodes... but that's a lot of work
}
