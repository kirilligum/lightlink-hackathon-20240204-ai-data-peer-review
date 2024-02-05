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

  it("Check if the initial keywords for reviewers are set correctly (empty at deployment)", async function () {
    const { peerReview, reviewer1, reviewer2, reviewer3 } = await loadFixture(deployPeerReviewFixture);

    // Since the contract does not provide a direct way to access a reviewer's keywords,
    // and assuming the contract or the test environment does not support such functionality yet,
    // this test will be outlined as a placeholder for future implementation when such functionality is available.
    // This comment serves as a reminder to implement the test when the contract supports querying reviewer keywords.
    console.log("Placeholder test for checking initial keywords of reviewers. Needs contract support for querying keywords.");
  });
});
