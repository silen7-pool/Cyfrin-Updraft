// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();

        SimpleStorage simpleStorage = new SimpleStorage();
        /*
        This way you can also deploy the contract with an initial value but the constructor needs to be payable:
        SimpleStorage simpleStorage = new SimpleStorage{value: 1ether}();
        */

        vm.stopBroadcast();
        return simpleStorage;
    }
}
