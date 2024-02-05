// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23 <0.9.0;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import { console2 } from "forge-std/src/console2.sol";
import { StdCheats } from "forge-std/src/StdCheats.sol";

import { PeerReview } from "../src/PeerReview.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract PeerReviewTest is PRBTest, StdCheats {
    PeerReview internal peerReview;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        // Instantiate the contract-under-test.
        address[] memory authors = new address[](2);
        authors[0] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // Anvil's local test account 1
        authors[1] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC; // Anvil's local test account 2

        address[] memory reviewers = new address[](4);
        reviewers[0] = 0x90F79bf6EB2c4f870365E785982E1f101E93b906; // Anvil's local test account 3
        reviewers[1] = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65; // Anvil's local test account 4
        reviewers[2] = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc; // Anvil's local test account 5
        reviewers[3] = 0x976EA74026E726554dB657fA54763abd0C3a0aa9; // Anvil's local test account 6

        peerReview = new PeerReview(authors, reviewers);
    }

}
