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



  describe("Deployment and Initialization", function () {
    it("Should store the correct number of authors and reviewers", async function () {
      const { reviewProcess, author, reviewer1, reviewer2, reviewer3, reviewer4 } = await loadFixture(deployPeerReviewFixture);

      const authors = await reviewProcess.authors();
      expect(authors.length).to.equal(1);
      expect(authors[0]).to.equal(author.address);

      const reviewersCount = await reviewProcess.reviewersCount();
      expect(reviewersCount).to.equal(4);
      expect(await reviewProcess.reviewers(0)).to.equal(reviewer1.address);
      expect(await reviewProcess.reviewers(1)).to.equal(reviewer2.address);
      expect(await reviewProcess.reviewers(2)).to.equal(reviewer3.address);
      expect(await reviewProcess.reviewers(3)).to.equal(reviewer4.address);
    });
  });
