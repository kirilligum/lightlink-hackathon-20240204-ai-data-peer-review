// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PeerReview {
  // Event declaration
  event SubmissionCreated(uint256 submissionId);
  // Event to emit the score of a reviewer
  event ScoreUpdated(address reviewer, uint256 score);

  constructor(address[] memory _authors, address[] memory _reviewerAddresses) {
    authors = _authors;
    for (uint256 i = 0; i < _reviewerAddresses.length; i++) {
      reviewers.push(Reviewer(_reviewerAddresses[i], new string[](0), 0));
    }
  }

  struct Reviewer {
    address addr;
    string[] keywords;
    uint256 score; // Added score field to keep track of each reviewer's score
  }

  struct Submission {
    address author;
    string question;
    string response;
    string metadata; // Added metadata
    mapping(address => bytes32) commits;
    mapping(address => bool) votes;
    address[] selectedReviewers;
    bool votingEnded;
    bool revealPhase;
    uint256 revealCount;
    bool isApproved;
  }

  address[] public authors;
  Reviewer[] public reviewers;
  Submission[] public submissions;
  string public constant LICENSE = "CC BY-NC-SA";
  uint256 public constant ROI_FEE_DENOMINATOR = 100;

  // Updated function for reviewers to add their keywords
  function addKeywords(string[] memory _keywords) public {
    bool isReviewer = false;
    for (uint256 i = 0; i < reviewers.length; i++) {
      if (reviewers[i].addr == msg.sender) {
        reviewers[i].keywords = _keywords;
        isReviewer = true;
        break;
      }
    }
    require(isReviewer, "Caller is not a reviewer.");
  }

  // Submit a data object
  function submitData(string memory _question, string memory _response) public returns (uint256) {
    Submission storage newSubmission = submissions.push();
    newSubmission.author = msg.sender;
    newSubmission.question = _question;
    newSubmission.response = _response;
    uint256 submissionId = submissions.length - 1;
    emit SubmissionCreated(submissionId);
    return submissionId;
  }

  // Find top 3 matching reviewers for a submission
  function findReviewers(uint256 submissionId) public {
    require(submissionId < submissions.length, "Invalid submission ID");
    Submission storage submission = submissions[submissionId];

    address[] memory topReviewers = new address[](3);
    uint256[] memory topReviewersValue = new uint256[](3);

    for (uint256 i = 0; i < reviewers.length; i++) {
      // reviewers[i].score = 0; // Reset score for each reviewer at the start
      for (uint256 j = 0; j < reviewers[i].keywords.length; j++) {
        if (
          contains(submission.question, reviewers[i].keywords[j]) ||
          contains(submission.response, reviewers[i].keywords[j])
        ) {
          reviewers[i].score++;
          emit ScoreUpdated(reviewers[i].addr, reviewers[i].score);
        }
      }

      if (reviewers[i].score >= topReviewersValue[0]) {
        topReviewers[0] = reviewers[i].addr;
      } else if (reviewers[i].score > topReviewersValue[1]) {
        topReviewers[1] = reviewers[i].addr;
      } else if (reviewers[i].score > topReviewersValue[2]) {
        topReviewers[2] = reviewers[i].addr;
      }
    }

    submission.selectedReviewers = topReviewers;
  }

  // function findReviewers(uint256 submissionId) public {
  //   require(submissionId < submissions.length, "Invalid submission ID");
  //   Submission storage submission = submissions[submissionId];

  //   uint256[] memory scores = new uint256[](reviewers.length);
  //   uint256 highestScore = 0;
  //   address[] memory topReviewers = new address[](3);
  //   uint256[] memory topReviewersValue = new uint256[](3);
  //   // for (uint256 i = 0; i < 3; i++) {
  //   //   topReviewers[i] = reviewers[i].addr;
  //   // }

  //   // Loop over all reviewers
  //   for (uint256 i = 0; i < reviewers.length; i++) {
  //     // Loop over each of the reviewer's keywords
  //     for (uint256 j = 0; j < reviewers[i].keywords.length; j++) {
  //       // Check if the keyword is in the submission's question or response
  //       if (
  //         contains(submission.question, reviewers[i].keywords[j]) ||
  //         contains(submission.response, reviewers[i].keywords[j])
  //       ) {
  //         scores[i]++;
  //         emit ScoreUpdated(reviewers[i].addr, scores[i]);
  //       }
  //     }

  //     if (scores[i] >= topReviewersValue[0]) {
  //       // topReviewersValue[2] = topReviewersValue[1];
  //       // topReviewersValue[1] = topReviewersValue[0];
  //       // topReviewersValue[0] = scores[i];
  //       // topReviewers[2] = topReviewers[1];
  //       // topReviewers[1] = topReviewers[0];
  //       topReviewers[0] = reviewers[i].addr;
  //     } else if (scores[i] > topReviewersValue[1]) {
  //       // topReviewersValue[2] = topReviewersValue[1];
  //       // topReviewersValue[1] = scores[i];
  //       // topReviewers[2] = topReviewers[1];
  //       topReviewers[1] = reviewers[i].addr;
  //     } else if (scores[i] > topReviewersValue[2]) {
  //       // topReviewersValue[2] = scores[i];
  //       topReviewers[2] = reviewers[i].addr;
  //     }

  //     // // Check if the current reviewer is among the top 3
  //     // if (scores[i] > highestScore) {
  //     //   highestScore = scores[i];
  //     //   topReviewers[2] = topReviewers[1];
  //     //   topReviewers[1] = topReviewers[0];
  //     //   topReviewers[0] = reviewers[i].addr;
  //     // }
  //   }

  //   // Assign top 3 reviewers to the submission
  //   submission.selectedReviewers = topReviewers;
  // }

  // A simple function to check if a string contains a substring
  function contains(string memory _string, string memory _substring) public pure returns (bool) {
    bytes memory stringBytes = bytes(_string);
    bytes memory substringBytes = bytes(_substring);

    // Simple loop to check substring
    for (uint256 i = 0; i < stringBytes.length - substringBytes.length; i++) {
      bool isMatch = true;
      for (uint256 j = 0; j < substringBytes.length; j++) {
        if (stringBytes[i + j] != substringBytes[j]) {
          isMatch = false;
          break;
        }
      }
      if (isMatch) return true;
    }
    return false;
  }

  // Function to get selected reviewers for a submission
  function getSelectedReviewers(uint256 submissionId) public view returns (address[] memory) {
    require(submissionId < submissions.length, "Invalid submission ID");
    return submissions[submissionId].selectedReviewers;
  }

  // Commit a vote as a hash
  function commitVote(uint256 submissionId, bytes32 commitHash) public {
    require(submissionId < submissions.length, "Invalid submission ID");
    Submission storage submission = submissions[submissionId];
    require(!submission.votingEnded, "Voting has ended");

    submission.commits[msg.sender] = commitHash;
  }

  // Reveal a vote
  function revealVote(
    uint256 submissionId,
    bool vote,
    bytes32 secret
  ) public {
    require(submissionId < submissions.length, "Invalid submission ID");
    Submission storage submission = submissions[submissionId];
    require(submission.votingEnded, "Voting has not ended");
    require(keccak256(abi.encodePacked(vote, secret)) == submission.commits[msg.sender], "Invalid commit");

    submission.votes[msg.sender] = vote;
    submission.revealCount++;

    if (submission.revealCount == submission.selectedReviewers.length) {
      submission.revealPhase = true;
      determineApproval(submissionId); // Determine if the submission is approved
    }
  }

  // Determine if the submission is approved based on majority vote
  function determineApproval(uint256 submissionId) internal {
    Submission storage submission = submissions[submissionId];
    uint256 approveCount = 0;

    for (uint256 i = 0; i < submission.selectedReviewers.length; i++) {
      if (submission.votes[submission.selectedReviewers[i]]) {
        approveCount++;
      }
    }

    submission.isApproved = approveCount > submission.selectedReviewers.length / 2;
  }

  // Function to display how reviewers voted after reveal phase
  function getReviewersVotes(uint256 submissionId) public view returns (address[] memory, bool[] memory) {
    require(submissionId < submissions.length, "Invalid submission ID");
    Submission storage submission = submissions[submissionId];
    require(submission.revealPhase, "Reveal phase not completed");

    address[] memory selectedReviewers = submission.selectedReviewers;
    bool[] memory votes = new bool[](selectedReviewers.length);

    for (uint256 i = 0; i < selectedReviewers.length; i++) {
      votes[i] = submission.votes[selectedReviewers[i]];
    }

    return (selectedReviewers, votes);
  }

  // End the voting phase
  function endVoting(uint256 submissionId) public {
    require(submissionId < submissions.length, "Invalid submission ID");
    Submission storage submission = submissions[submissionId];
    submission.votingEnded = true;
  }

  // Get all approved reviewers for a submission
  function getApprovedReviewers(uint256 submissionId) public view returns (address[] memory) {
    require(submissionId < submissions.length, "Invalid submission ID");
    Submission storage submission = submissions[submissionId];
    require(submission.revealPhase, "Reveal phase not completed");

    address[] memory approvedReviewers = new address[](submission.selectedReviewers.length);
    uint256 count = 0;

    for (uint256 i = 0; i < submission.selectedReviewers.length; i++) {
      if (submission.votes[submission.selectedReviewers[i]]) {
        approvedReviewers[count] = submission.selectedReviewers[i];
        count++;
      }
    }

    // Resize the array to fit the actual number of approved reviewers
    address[] memory resizedApprovedReviewers = new address[](count);
    for (uint256 i = 0; i < count; i++) {
      resizedApprovedReviewers[i] = approvedReviewers[i];
    }

    return resizedApprovedReviewers;
  }

  // Function to get the number of reviewers
  function getReviewersCount() public view returns (uint256) {
    return reviewers.length;
  }

  // Function to get the number of authors
  function getAuthorsCount() public view returns (uint256) {
    return authors.length;
  }

  // Function to get keywords for a specific reviewer
  function getReviewerKeywords(address reviewerAddress) public view returns (string[] memory) {
    for (uint256 i = 0; i < reviewers.length; i++) {
      if (reviewers[i].addr == reviewerAddress) {
        return reviewers[i].keywords;
      }
    }
    revert("Reviewer not found.");
  }
}
