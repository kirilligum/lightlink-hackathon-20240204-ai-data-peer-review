const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

async function deployPeerReviewFixture() {
  const [deployer, author1, reviewer1, reviewer2, reviewer3] = await ethers.getSigners();
  const PeerReview = await ethers.getContractFactory("PeerReview");
  const peerReview = await PeerReview.deploy([author1.address], [reviewer1.address, reviewer2.address, reviewer3.address]);
  return { peerReview, author1, reviewer1, reviewer2, reviewer3 };
}

describe("PeerReview Contract Deployment and Initialization Test", function () {
  it("Should deploy the contract with predefined authors and reviewers, and verify initial settings", async function () {
    const { peerReview, author1, reviewer1, reviewer2, reviewer3 } = await loadFixture(deployPeerReviewFixture);

    // Verify if the contract stores the correct number of authors and reviewers
    const author0 = await peerReview.authors(0);
    expect(author0).to.equal(author1.address);

    // Access the reviewers array length directly
    const reviewersCount = await peerReview.getReviewersCount();
    expect(reviewersCount).to.equal(3);

  });
});
