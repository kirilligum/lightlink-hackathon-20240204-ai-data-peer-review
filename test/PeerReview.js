const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeerReview contract", function () {
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

  describe("Deployment", function () {
    it("Should deploy with the correct initial setup", async function () {
      const { reviewProcess, author, reviewer1, reviewer2, reviewer3, reviewer4 } = await loadFixture(deployPeerReviewFixture);

      // Add assertions to check the initial setup
    });
  });

  describe("Submit and review process", function () {
    it("Should allow an author to submit data", async function () {
      const { reviewProcess, author } = await loadFixture(deployPeerReviewFixture);

      // Example submission
      await expect(reviewProcess.connect(author).submitData(
        "why do we need gasless transactions?",
        "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns."
      )).to.not.be.reverted;
    });

    it("Should correctly find and assign reviewers based on keywords", async function () {
      // Implement the test to check if the correct reviewers are assigned based on keywords
    });

    it("Reviewers should be able to commit and reveal votes", async function () {
      // Implement the test to check if reviewers can commit and reveal their votes correctly
    });

    it("Should correctly determine the approval of a submission based on votes", async function () {
      // Implement the test to check if the contract correctly determines the approval of a submission
    });
  });
});
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
