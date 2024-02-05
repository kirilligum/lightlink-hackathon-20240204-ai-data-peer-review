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
describe("Deployment and Initialization Test", function () {
  it("Should deploy the contract with predefined authors and reviewers and verify their setup", async function () {
    const { reviewProcess, author, reviewer1, reviewer2, reviewer3, reviewer4 } = await loadFixture(deployPeerReviewFixture);

    // Assuming a function exists to fetch the total number of authors
    const totalAuthors = await reviewProcess.getTotalAuthors();
    expect(totalAuthors).to.equal(1);

    // Assuming a function exists to fetch the total number of reviewers
    const totalReviewers = await reviewProcess.getTotalReviewers();
    expect(totalReviewers).to.equal(4);

    // Assuming a function exists to fetch a reviewer's keywords by their address
    // Verify the keywords for each reviewer
    const keywordsReviewer1 = await reviewProcess.getReviewerKeywords(reviewer1.address);
    expect(keywordsReviewer1).to.deep.equal(["gasless", "blockchain"]);

    const keywordsReviewer2 = await reviewProcess.getReviewerKeywords(reviewer2.address);
    expect(keywordsReviewer2).to.deep.equal([]);

    const keywordsReviewer3 = await reviewProcess.getReviewerKeywords(reviewer3.address);
    expect(keywordsReviewer3).to.deep.equal(["transactions"]);

    const keywordsReviewer4 = await reviewProcess.getReviewerKeywords(reviewer4.address);
    expect(keywordsReviewer4).to.deep.equal(["fees"]);
  });
});
