const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeerReview Contract", function () {
  it("Should correctly set the author's address during construction", async function () {
    const [owner] = await ethers.getSigners();
    const PeerReview = await ethers.getContractFactory("PeerReview");
    const peerReview = await PeerReview.deploy([owner.address], []);


    const authors = await peerReview.authors();
    expect(authors[0]).to.equal(owner.address);
  });
});
