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

    // Simulate reviewer 1 adding keywords
    vm.startPrank(0x90F79bf6EB2c4f870365E785982E1f101E93b906); // Simulate call from reviewer 1's address
    string[] memory keywordsReviewer1 = new string[](2);
    keywordsReviewer1[0] = "gasless";
    keywordsReviewer1[1] = "blockchain";
    peerReview.addKeywords(keywordsReviewer1);
    vm.stopPrank();

    // Simulate reviewer 3 adding keywords
    vm.startPrank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc); // Simulate call from reviewer 3's address
    string[] memory keywordsReviewer3 = new string[](1);
    keywordsReviewer3[0] = "transactions";
    peerReview.addKeywords(keywordsReviewer3);
    vm.stopPrank();

    // Simulate reviewer 4 adding keywords
    vm.startPrank(0x976EA74026E726554dB657fA54763abd0C3a0aa9); // Simulate call from reviewer 3's address
    string[] memory keywordsReviewer4 = new string[](1);
    keywordsReviewer4[0] = "fees";
    peerReview.addKeywords(keywordsReviewer4);
    vm.stopPrank();

    // Simulate an author submitting a data object
    vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8); // Simulate call from author's address
    string memory question = "why do we need gasless transactions?";
    string
      memory response = "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns.";
    peerReview.submitData(question, response);
    vm.stopPrank();
  }

  /// @dev Test for revealing votes by reviewers
  function testRevealingVotes() public {
    // Generate commit hashes for three reviewers using contract functions
    bytes32 commitHash1 = peerReview.createCommitHashTrue(hex"03301b3328418a6f426a79f8f4519483");
    bytes32 commitHash2 = peerReview.createCommitHashTrue(hex"8e0b79052a49a89943887bc0fbc72882");
    bytes32 commitHash3 = peerReview.createCommitHashFalse(hex"512da4641020358f91de50b68983ce05");

    // Simulate reviewers committing their votes
    vm.startPrank(0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    peerReview.commitVote(0, commitHash1);
    vm.stopPrank();

    vm.startPrank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
    peerReview.commitVote(0, commitHash2);
    vm.stopPrank();

    vm.startPrank(0x976EA74026E726554dB657fA54763abd0C3a0aa9);
    peerReview.commitVote(0, commitHash3);
    vm.stopPrank();

    // End voting to allow revealing
    peerReview.endVoting(0);

    // Simulate reviewers revealing their votes
    vm.startPrank(0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    peerReview.revealVote(0, true, hex"03301b3328418a6f426a79f8f4519483");
    vm.stopPrank();

    vm.startPrank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
    peerReview.revealVote(0, true, hex"8e0b79052a49a89943887bc0fbc72882");
    vm.stopPrank();

    vm.startPrank(0x976EA74026E726554dB657fA54763abd0C3a0aa9);
    peerReview.revealVote(0, false, hex"512da4641020358f91de50b68983ce05");
    vm.stopPrank();

    // Verify the votes are revealed correctly
    assertTrue(peerReview.getReviewerVote(0, 0x90F79bf6EB2c4f870365E785982E1f101E93b906), "Reviewer 1's vote should be true.");
    assertTrue(peerReview.getReviewerVote(0, 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc), "Reviewer 3's vote should be true.");
    assertFalse(peerReview.getReviewerVote(0, 0x976EA74026E726554dB657fA54763abd0C3a0aa9), "Reviewer 4's vote should be false.");
  }

  /// @dev Test for verifying the number of authors and reviewers.
  function testConstructorInitialization() public {
    // Verify the correct number of authors
    uint256 authorsCount = peerReview.getAuthorsCount();
    assertEq(authorsCount, 2, "Incorrect number of authors initialized.");

    // Verify the correct number of reviewers
    uint256 reviewersCount = peerReview.getReviewersCount();
    assertEq(reviewersCount, 4, "Incorrect number of reviewers initialized.");
  }

  function testAddingKeywordsByReviewer1() public {
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
    // Verify the keywords are correctly added for reviewer 3
    string[] memory returnedKeywords = peerReview.getReviewerKeywords(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
    assertEq(returnedKeywords.length, 1);
    assertEq(returnedKeywords[0], "transactions");
  }

  function testAddingKeywordsByReviewer4() public {
    // Verify the keywords are correctly added for reviewer 4
    string[] memory returnedKeywords = peerReview.getReviewerKeywords(0x976EA74026E726554dB657fA54763abd0C3a0aa9);
    assertEq(returnedKeywords.length, 1);
    assertEq(returnedKeywords[0], "fees");
  }

  function testContainsFunction() public {
    // Test cases where the substring is present in the string
    assertTrue(
      peerReview.contains("blockchain technology", "chain"),
      "The string 'blockchain technology' contains 'chain'"
    );
    assertTrue(
      peerReview.contains("gasless transactions are innovative", "less"),
      "The string 'gasless transactions are innovative' contains 'less'"
    );

    // Test cases where the substring is not present in the string
    assertFalse(peerReview.contains("smart contract", "block"), "The string 'smart contract' does not contain 'block'");
    assertFalse(
      peerReview.contains("decentralized finance", "fee"),
      "The string 'decentralized finance' does not contain 'fee'"
    );
  }

  function testSubmissionOfDataByAuthor() public {
    // Verify the submission is stored with the correct author, question, and response
    vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8); // Simulate call from author's address
    string memory question = "why do we need gasless transactions?";
    string
      memory response = "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns.";
    uint256 submissionId = 0;
    // uint256 submissionId = peerReview.submitData(question, response);
    (address author, string memory storedQuestion, string memory storedResponse, , , , , ) = peerReview.submissions(
      submissionId
    );
    assertEq(author, 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
    assertEq(storedQuestion, question);
    assertEq(storedResponse, response);
  }

  function testFindingSuitableReviewers() public {
    // Trigger the function to find suitable reviewers for the submission
    // peerReview.findReviewers(submissionId);
    peerReview.findReviewers(0);
    // Verify the top 3 reviewers are selected based on the highest keyword matches
    address[] memory selectedReviewers = peerReview.getSelectedReviewers(0);
    assertEq(selectedReviewers.length, 3, "Should select 3 reviewers.");
    assertEq(selectedReviewers[0], 0x90F79bf6EB2c4f870365E785982E1f101E93b906, "Reviewer 1 should be selected.");
    assertEq(selectedReviewers[1], 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc, "Reviewer 3 should be selected.");
    assertEq(selectedReviewers[2], 0x976EA74026E726554dB657fA54763abd0C3a0aa9, "Reviewer 4 should be selected.");
  }

  /// @dev Test for committing votes by reviewers
  function testCommittingVotes() public {
    // Simulate reviewers committing their votes using a hash
    bytes32 commitHash1 = 0xc84fd4e93dad9c9112c18633717eecf901df6fd6adf86985627dc9ec33b0a2ee;
    bytes32 commitHash2 = 0x9a1658b75a569dfcb7d3157a02a6d66b61acbb11fb8faa85611ffda088fa730c;
    bytes32 commitHash3 = 0xd3b8e57201f503553e68903eabd106060dd2e648c44f5c1b087cc45cebb1fbf7;

    // Commit votes for three reviewers
    vm.startPrank(0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    peerReview.commitVote(0, commitHash1);
    vm.stopPrank();

    vm.startPrank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
    peerReview.commitVote(0, commitHash2);
    vm.stopPrank();

    vm.startPrank(0x976EA74026E726554dB657fA54763abd0C3a0aa9);
    peerReview.commitVote(0, commitHash3);
    vm.stopPrank();

    // Verify the commit hash is stored correctly for each reviewer
    assertEq(
      peerReview.getCommitHash(0, 0x90F79bf6EB2c4f870365E785982E1f101E93b906),
      commitHash1,
      "Commit hash for reviewer 1 does not match."
    );
    assertEq(
      peerReview.getCommitHash(0, 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc),
      commitHash2,
      "Commit hash for reviewer 3 does not match."
    );
    assertEq(
      peerReview.getCommitHash(0, 0x976EA74026E726554dB657fA54763abd0C3a0aa9),
      commitHash3,
      "Commit hash for reviewer 4 does not match."
    );
  }
}
