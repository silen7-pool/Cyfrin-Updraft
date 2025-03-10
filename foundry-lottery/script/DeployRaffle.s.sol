// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";

import {CreateSubscription, FundSubscription, AddConsumer, GetSubscriptionBalance} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig(); // This comes with our mocks!
        AddConsumer addConsumer = new AddConsumer();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        if (config.subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription();
            (
                config.subscriptionId,
                config.vrfCoordinatorV2_5
            ) = createSubscription.createSubscription(
                config.vrfCoordinatorV2_5,
                config.account
            );

            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(
                config.vrfCoordinatorV2_5,
                config.subscriptionId,
                config.link,
                config.account
            );

            helperConfig.setConfig(block.chainid, config);
        }

        // Will send 3 link if the balance is less than 1 link for the subId and network is different than local chain

        GetSubscriptionBalance getSubscriptionBalance = new GetSubscriptionBalance();
        uint96 balanceInLink = getSubscriptionBalance.getSubscriptionBalance(
            config.vrfCoordinatorV2_5,
            config.subscriptionId
        );
        if (block.chainid != 31337 && balanceInLink < 1 ether) {
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(
                config.vrfCoordinatorV2_5,
                config.subscriptionId,
                config.link,
                config.account
            );
        }

        vm.startBroadcast(config.account);
        Raffle raffle = new Raffle(
            config.subscriptionId,
            config.gasLane,
            config.automationUpdateInterval,
            config.raffleEntranceFee,
            config.callbackGasLimit,
            config.vrfCoordinatorV2_5
        );
        vm.stopBroadcast();

        // We already have a broadcast in AddConsumer contract in Interactions.s.sol
        addConsumer.addConsumer(
            address(raffle),
            config.vrfCoordinatorV2_5,
            config.subscriptionId,
            config.account
        );

        return (raffle, helperConfig);
    }
}
