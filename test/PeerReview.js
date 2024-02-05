const ReviewProcess = artifacts.require("ReviewProcess");

contract("ReviewProcess Deployment and Initialization", (accounts) => {
  it("should deploy with predefined authors and reviewers", async () => {
    const authors = [accounts[1], accounts[2]];
    const reviewers = [accounts[3], accounts[4], accounts[5]];

    const reviewProcessInstance = await ReviewProcess.new(authors, reviewers);

    const storedAuthors = await reviewProcessInstance.authors();
    const storedReviewersCount = await reviewProcessInstance.reviewersCount();

    assert.equal(storedAuthors.length, authors.length, "Incorrect number of authors stored");
    assert.equal(storedReviewersCount, reviewers.length, "Incorrect number of reviewers stored");

    // Additional checks for initial keywords for reviewers can be added here
  });
});
