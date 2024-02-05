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
