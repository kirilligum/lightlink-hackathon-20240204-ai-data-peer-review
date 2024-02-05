const { expect } = require("chai");

describe("PeerReview contract", function () {
  let PeerReview;
  let peerReview;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    PeerReview = await ethers.getContractFactory("PeerReview");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    peerReview = await PeerReview.deploy([owner.address, addr1.address], [{addr: addr2.address, keywords: ["blockchain", "transactions"]}]);
  });

  describe("Deployment", function () {
    it("Should set the right authors", async function () {
      expect(await peerReview.authors(0)).to.equal(owner.address);
      expect(await peerReview.authors(1)).to.equal(addr1.address);
    });

    it("Should set the right reviewers", async function () {
      expect((await peerReview.reviewers(0)).addr).to.equal(addr2.address);
    });
  });

  describe("Submit data", function () {
    it("Should allow authors to submit data", async function () {
      await peerReview.connect(owner).submitData("why do we need gasless transactions?", "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns.");
      expect((await peerReview.submissions(0)).author).to.equal(owner.address);
    });

    it("Should not allow non-authors to submit data", async function () {
      await expect(peerReview.connect(addr2).submitData("why do we need gasless transactions?", "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns.")).to.be.reverted;
    });
  });

  describe("Find reviewers", function () {
    it("Should find top 3 matching reviewers for a submission", async function () {
      await peerReview.connect(owner).submitData("why do we need gasless transactions?", "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns.");
      await peerReview.findReviewers(0);
      expect((await peerReview.submissions(0)).selectedReviewers[0]).to.equal(addr2.address);
    });
  });

  // Add more tests as needed...
});
