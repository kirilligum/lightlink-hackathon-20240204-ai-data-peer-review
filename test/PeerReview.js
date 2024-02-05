const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

// Load the fixture for the test environment
async function deployPeerReviewFixture() {
  const [deployer, author, reviewer1, reviewer2, reviewer3, reviewer4] = await ethers.getSigners();

  const ReviewProcess = await ethers.getContractFactory("ReviewProcess");
  const reviewProcess = await ReviewProcess.deploy(
    [author.address], // Authors
    [
      reviewer1.address,
      reviewer2.address,
      reviewer3.address,
      reviewer4.address,
    ] // Reviewers
  );

  return { reviewProcess, deployer, author, reviewer1, reviewer2, reviewer3, reviewer4 };
}
