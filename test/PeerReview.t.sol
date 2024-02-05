// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23 <0.9.0;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import { console2 } from "forge-std/src/console2.sol";
import { StdCheats } from "forge-std/src/StdCheats.sol";

import { PeerReview } from "../src/PeerReview.sol";

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

  function testAddingKeywordsByReviewer1() public {
    // Simulate reviewer 1 adding keywords
    vm.startPrank(0x90F79bf6EB2c4f870365E785982E1f101E93b906); // Simulate call from reviewer 1's address
    string[] memory keywords = new string[](2);
    keywords[0] = "gasless";
    keywords[1] = "blockchain";
    peerReview.addKeywords(keywords);
    vm.stopPrank();

    // Verify the keywords are correctly added for reviewer 1
    string[] memory returnedKeywords = peerReview.getReviewerKeywords(0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    assertEq(returnedKeywords.length, 2);
    assertEq(returnedKeywords[0], "gasless");
    assertEq(returnedKeywords[1], "blockchain");
  }

  function testReviewer2HasNoKeywords() public {
    // Verify the second reviewer has no keywords
    string[] memory returnedKeywords = peerReview.getReviewerKeywords(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65);
    assertEq(returnedKeywords.length, 0);
  }

  function testAddingKeywordsByReviewer3() public {
    // Simulate reviewer 3 adding keywords
    vm.startPrank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc); // Simulate call from reviewer 3's address
    string[] memory keywords = new string[](1);
    keywords[0] = "transactions";
    peerReview.addKeywords(keywords);
    vm.stopPrank();

    // Verify the keywords are correctly added for reviewer 3
    string[] memory returnedKeywords = peerReview.getReviewerKeywords(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
    assertEq(returnedKeywords.length, 1);
    assertEq(returnedKeywords[0], "transactions");
  }

  function testAddingKeywordsByReviewer4() public {
    // Simulate reviewer 4 adding keywords
    vm.startPrank(0x976EA74026E726554dB657fA54763abd0C3a0aa9); // Simulate call from reviewer 4's address
    string[] memory keywords = new string[](1);
    keywords[0] = "fees";
    peerReview.addKeywords(keywords);
    vm.stopPrank();

    // Verify the keywords are correctly added for reviewer 4
    string[] memory returnedKeywords = peerReview.getReviewerKeywords(0x976EA74026E726554dB657fA54763abd0C3a0aa9);
    assertEq(returnedKeywords.length, 1);
    assertEq(returnedKeywords[0], "fees");
  }

  function testSubmissionOfDataByAuthor() public {
    // Simulate an author submitting a data object
    vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8); // Simulate call from author's address
    string memory question = "why do we need gasless transactions?";
    string
      memory response = "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns.";
    uint256 submissionId = peerReview.submitData(question, response);
    vm.stopPrank();

    // Verify the submission is stored with the correct author, question, and response
    (address author, string memory storedQuestion, string memory storedResponse, , , , , ) = peerReview.submissions(
      submissionId
    );
    assertEq(author, 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
    assertEq(storedQuestion, question);
    assertEq(storedResponse, response);
  }
}
