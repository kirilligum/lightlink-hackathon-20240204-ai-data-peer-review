const { expect } = require("chai");
const { ethers } = require("hardhat");

async function deployPeerReviewFixture() {
  const [deployer, author1, reviewer1, reviewer2, reviewer3] = await ethers.getSigners();
  const PeerReview = await ethers.getContractFactory("PeerReview");
  const peerReview = await PeerReview.deploy([author1.address], [reviewer1.address, reviewer2.address, reviewer3.address]);
  await peerReview.deployed();
  return { peerReview, author1, reviewer1, reviewer2, reviewer3 };
}

describe("PeerReview Contract Deployment and Initialization Test", function () {
  it("Should deploy the contract with predefined authors and reviewers, and verify initial settings", async function () {
    const { peerReview, author1, reviewer1, reviewer2, reviewer3 } = await loadFixture(deployPeerReviewFixture);

    // Verify if the contract stores the correct number of authors and reviewers
    const authors = await peerReview.authors();
    expect(authors.length).to.equal(1);
    expect(authors[0]).to.equal(author1.address);

    // Assuming reviewersCount is a hypothetical function to get the count of reviewers
    const reviewersCount = await peerReview.reviewersCount();
    expect(reviewersCount).to.equal(3);

    // Check if the initial keywords for reviewers are set correctly (empty at deployment)
    for (let i = 0; i < reviewersCount; i++) {
      const reviewer = await peerReview.reviewers(i);
      expect(reviewer.keywords.length).to.equal(0);
    }
  });
});
