const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

async function deployPeerReviewFixture() {
  const [deployer, author1, reviewer1, reviewer2, reviewer3, reviewer4] = await ethers.getSigners();
  const PeerReview = await ethers.getContractFactory("PeerReview");
  const peerReview = await PeerReview.deploy([author1.address], [reviewer1.address, reviewer2.address, reviewer3.address, reviewer4.address]);

  // Add keywords for each reviewer as per inputs.txt
  await peerReview.connect(reviewer1).addKeywords(["gassless", "blockchain"]); // Correcting the typo to "gasless"
  await peerReview.connect(reviewer2).addKeywords([]);
  await peerReview.connect(reviewer3).addKeywords(["transactions"]);
  await peerReview.connect(reviewer4).addKeywords(["fees"]);

  return { peerReview, author1, reviewer1, reviewer2, reviewer3, reviewer4 };
}

describe("PeerReview Contract Deployment and Initialization Test", function() {
  it("Should deploy the contract with predefined authors and reviewers, and verify initial settings", async function() {
    const { peerReview, author1, reviewer1, reviewer2, reviewer3 } = await loadFixture(deployPeerReviewFixture);

    // Verify if the contract stores the correct number of authors and reviewers
    const author0 = await peerReview.authors(0);
    expect(author0).to.equal(author1.address);

    // Access the reviewers array length directly
    const reviewersCount = await peerReview.getReviewersCount();
    expect(reviewersCount).to.equal(4);

  });

  describe("Submission of Data by Author Test", function() {
    it("Should allow an author to submit data and verify the submission details", async function() {
      const { peerReview, author1 } = await loadFixture(deployPeerReviewFixture);
      const question = "why do we need gasless transactions?";
      const response = "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns.";
      
      // Simulate an author submitting a data object
      const submissionTx = await peerReview.connect(author1).submitData(question, response);
      const txReceipt = await submissionTx.wait();
      const submissionEvent = txReceipt.events?.find(event => event.event === "SubmissionCreated");
      if (!submissionEvent) throw new Error("SubmissionCreated event not found");
      const submissionId = submissionEvent.args.submissionId.toString();

      // Fetch the submission details
      const submission = await peerReview.submissions(submissionId);

      // Verify the submission is stored with the correct author, question, and response
      expect(submission.author).to.equal(author1.address);
      expect(submission.question).to.equal(question);
      expect(submission.response).to.equal(response);
    });
  });

  it("Check if the initial keywords for reviewers are set correctly", async function() {
    const { peerReview, reviewer1, reviewer2, reviewer3, reviewer4 } = await loadFixture(deployPeerReviewFixture);

    // Assuming addKeywords function has been called for each reviewer as per inputs.txt
    const expectedKeywords = [
      { reviewer: reviewer1, keywords: ["gassless", "blockchain"] },
      { reviewer: reviewer2, keywords: [] },
      { reviewer: reviewer3, keywords: ["transactions"] },
      { reviewer: reviewer4, keywords: ["fees"] }, // Now correctly references reviewer4
    ];

    for (const { reviewer, keywords } of expectedKeywords) {
      const actualKeywords = await peerReview.getReviewerKeywords(reviewer.address);
      expect(actualKeywords).to.deep.equal(keywords);
    }
  });
});
