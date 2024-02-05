const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeerReview Contract", function () {
  it("Should correctly set the author's address during construction", async function () {
    const [owner] = await ethers.getSigners();
    const PeerReview = await ethers.getContractFactory("PeerReview");
    const peerReview = await PeerReview.deploy([owner.address], []);


    const authorAddress = await peerReview.authors(0);
    expect(authorAddress).to.equal(owner.address);
  });
});
