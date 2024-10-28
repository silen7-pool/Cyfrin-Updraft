// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        deployFundMe = new DeployFundMe();

        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedAddress() public view {
        AggregatorV3Interface priceFeedAddress = fundMe.getPriceFeed();
        assertEq(
            address(priceFeedAddress),
            address(0x694AA1769357215DE4FAC081bf1f309aDC325306)
        );
    }

    // forge test --mt testPriceFeedVersionIsAccurate --fork-url $SEPOLIA_ALCHEMY_RPC_URL -vvvvv
    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        console.log(version);
        assertEq(version, 4);
    }
}
