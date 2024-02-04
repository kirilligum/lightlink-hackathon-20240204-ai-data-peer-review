// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReviewProcess {
    struct Reviewer {
        address addr;
        string[] keywords;
    }

    struct Submission {
        address author;
        string question;
        string response;
        mapping(address => bytes32) commits;
        mapping(address => bool) votes;
        address[] selectedReviewers;
        bool votingEnded;
        bool revealPhase;
        uint revealCount;
    }

    address[] public authors;
    Reviewer[] public reviewers;
    Submission[] public submissions;

    // Register an author
    function registerAuthor(address _author) public {
        authors.push(_author);
    }

    // Register a reviewer with keywords
    function registerReviewer(address _reviewer, string[] memory _keywords) public {
        reviewers.push(Reviewer(_reviewer, _keywords));
    }

    // Submit a data object
    function submitData(string memory _question, string memory _response) public returns(uint) {
        Submission storage newSubmission = submissions.push();
        newSubmission.author = msg.sender;
        newSubmission.question = _question;
        newSubmission.response = _response;
        return submissions.length - 1;
    }

    // Find top 3 matching reviewers for a submission
    function findReviewers(uint submissionId) public {
        require(submissionId < submissions.length, "Invalid submission ID");
        Submission storage submission = submissions[submissionId];

        uint[] memory scores = new uint[](reviewers.length);
        uint highestScore = 0;
        address[] memory topReviewers = new address[](3);

        // Loop over all reviewers
        for(uint i = 0; i < reviewers.length; i++) {
            // Loop over each of the reviewer's keywords
            for(uint j = 0; j < reviewers[i].keywords.length; j++) {
                // Check if the keyword is in the submission's question or response
                if (contains(submission.question, reviewers[i].keywords[j]) || contains(submission.response, reviewers[i].keywords[j])) {
                    scores[i]++;
                }
            }

            // Check if the current reviewer is among the top 3
            if (scores[i] > highestScore) {
                highestScore = scores[i];
                topReviewers[2] = topReviewers[1];
                topReviewers[1] = topReviewers[0];
                topReviewers[0] = reviewers[i].addr;
            }
        }

        // Assign top 3 reviewers to the submission
        submission.selectedReviewers = topReviewers;
    }

    // A simple function to check if a string contains a substring
    function contains(string memory _string, string memory _substring) private pure returns (bool) {
        bytes memory stringBytes = bytes(_string);
        bytes memory substringBytes = bytes(_substring);

        // Simple loop to check substring
        for(uint i = 0; i < stringBytes.length - substringBytes.length; i++) {
            bool isMatch = true;
            for(uint j = 0; j < substringBytes.length; j++) {
                if (stringBytes[i + j] != substringBytes[j]) {
                    isMatch = false;
                    break;
                }
            }
            if (isMatch) return true;
        }
        return false;
    }

    // Commit a vote as a hash
    function commitVote(uint submissionId, bytes32 commitHash) public {
        require(submissionId < submissions.length, "Invalid submission ID");
        Submission storage submission = submissions[submissionId];
        require(!submission.votingEnded, "Voting has ended");

        submission.commits[msg.sender] = commitHash;
    }

    // Reveal a vote
    function revealVote(uint submissionId, bool vote, bytes32 secret) public {
        require(submissionId < submissions.length, "Invalid submission ID");
        Submission storage submission = submissions[submissionId];
        require(submission.votingEnded, "Voting has not ended");
        require(keccak256(abi.encodePacked(vote, secret)) == submission.commits[msg.sender], "Invalid commit");

        submission.votes[msg.sender] = vote;
        submission.revealCount++;

        if (submission.revealCount == submission.selectedReviewers.length) {
            submission.revealPhase = true;
            // Perform actions after all votes are revealed
        }
    }

    // End the voting phase
    function endVoting(uint submissionId) public {
        require(submissionId < submissions.length, "Invalid submission ID");
        Submission storage submission = submissions[submissionId];
        submission.votingEnded = true;
    }

    // Get all approved reviewers for a submission
    function getApprovedReviewers(uint submissionId) public view returns (address[] memory) {
        require(submissionId < submissions.length, "Invalid submission ID");
        Submission storage submission = submissions[submissionId];
        require(submission.revealPhase, "Reveal phase not completed");

        address[] memory approvedReviewers = new address[](submission.selectedReviewers.length);
        uint count = 0;

        for (uint i = 0; i < submission.selectedReviewers.length; i++) {
            if (submission.votes[submission.selectedReviewers[i]]) {
                approvedReviewers[count] = submission.selectedReviewers[i];
                count++;
            }
        }

        // Resize the array to fit the actual number of approved reviewers
        address[] memory resizedApprovedReviewers = new address[](count);
        for (uint i = 0; i < count; i++) {
            resizedApprovedReviewers[i] = approvedReviewers[i];
        }

        return resizedApprovedReviewers;
    }
}

