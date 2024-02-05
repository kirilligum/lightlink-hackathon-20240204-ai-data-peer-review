const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeerReview contract", function() {
  // Load the fixture for the test environment
  async function deployPeerReviewFixture() {
    const [deployer, author, reviewer1, reviewer2, reviewer3, reviewer4] = await ethers.getSigners();

    const ReviewProcess = await ethers.getContractFactory("ReviewProcess");
    const reviewProcess = await ReviewProcess.deploy(
      [author.address], // Authors
      [
        [reviewer1.address, ["gasless", "blockchain"]],
        [reviewer2.address, []],
        [reviewer3.address, ["transactions"]],
        [reviewer4.address, ["fees"]]
      ] // Reviewers
    );

    return { reviewProcess, deployer, author, reviewer1, reviewer2, reviewer3, reviewer4 };
  }

});
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
