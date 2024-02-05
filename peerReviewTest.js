const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeerReview Contract Deployment and Initialization Test", function () {
  it("Should deploy the contract and verify authors and reviewers", async function () {
    const [deployer, ...accounts] = await ethers.getSigners();
    const authors = [accounts[0].address, accounts[1].address];
    const reviewers = [accounts[2].address, accounts[3].address, accounts[4].address];

    const PeerReview = await ethers.getContractFactory("PeerReview");
    const peerReview = await PeerReview.deploy(authors, reviewers);

    await peerReview.deployed();

    // Verify the correct number of authors and reviewers
    expect(await peerReview.authors()).to.deep.equal(authors);
    expect(await peerReview.reviewers.length).to.equal(reviewers.length);

    // Additional checks can be implemented here for keywords if they are set during deployment
  });
});
