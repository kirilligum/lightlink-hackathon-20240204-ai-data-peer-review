const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeerReview Contract", function () {
  it("Should return the correct number of authors after construction", async function () {
    const [owner, author, reviewer1, reviewer2, reviewer3] = await ethers.getSigners();
    const PeerReview = await ethers.getContractFactory("PeerReview");
    const peerReview = await PeerReview.deploy([author.address], [reviewer1.address, reviewer2.address, reviewer3.address]);

    await peerReview.deployed();

    const authors = await peerReview.authors();
    const reviewers = await peerReview.reviewers();
    expect(authors.length).to.equal(1);
    expect(reviewers.length).to.equal(3);
  });
});
