// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {StorageTest} from "../src/exampleContracts/StorageTest.sol";

contract DeployStorageTest is Script {
    function run() external returns (StorageTest) {
        vm.startBroadcast();
        StorageTest storageTest = new StorageTest();
        vm.stopBroadcast();
        return (storageTest);
    }
}
