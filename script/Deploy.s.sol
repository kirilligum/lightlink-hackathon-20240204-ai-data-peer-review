// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23 <0.9.0;

import { PeerReview } from "../src/PeerReview.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast returns (PeerReview peerReview) {
        address[] memory authors = new address[](2);
        authors[0] = address(1); // Anvil's local test account 1
        authors[1] = address(2); // Anvil's local test account 2

        address[] memory reviewers = new address[](4);
        reviewers[0] = address(3); // Anvil's local test account 3
        reviewers[1] = address(4); // Anvil's local test account 4
        reviewers[2] = address(5); // Anvil's local test account 5
        reviewers[3] = address(6); // Anvil's local test account 6

        peerReview = new PeerReview(authors, reviewers);
    }
}
