const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeerReview Contract", function () {
  it("Should return the correct number of authors after construction", async function () {
    const [owner, addr1, addr2, addr3] = await ethers.getSigners();
    const PeerReview = await ethers.getContractFactory("PeerReview");
    const peerReview = await PeerReview.deploy([addr1.address, addr2.address, addr3.address], []);

    await peerReview.deployed();

    const authors = await peerReview.authors();
    expect(authors.length).to.equal(3);
  });
});
