# Front End Layout Schema (Single Page)

## welcome
- Welcome to the Peer Review Platform
- Authors and reviewers have been assigned during the contract creation process
- Authors: {authors}
- Reviewers: {reviewers}

## Reviewers
- Reviewers: Update Your Keywords
- __Keywords__
- [ Update ]

## Authors
- Authors: Submit Your Data Object
- _question_
- _response_
- [ submit ]
- [ find reviewers ]

## Reviewers
- Reviewers: Review Assignments
- { Question }
- { Response }
- _commitHash_
- [ Submit Blind Vote ]

## end vote
- [ end vote ]

## Reviewers: Reveal
- Reveal Your Vote
- _vote_
- _secret_
- [ Submit ]

## generate Decision
- decision based on majority vote
- [ get decision ]

## decision
- {decision}


fields:

LICENSE Read function
ROI_FEE_DENOMINATOR Read function
addKeywords Write function with args
authors Read function with args
commitVote  Write function with args
contains  Payable write function with args
createCommitHashFalse Payable write function with args
createCommitHashTrue  Payable write function with args
endVoting Write function with args
findReviewers Write function with args
getApprovedReviewers  Read function with args
getAuthorsCount Read function
getCommitHash Read function with args
getReviewerKeywords Read function with args
getReviewerVote Read function with args
getReviewersCount Read function
getReviewersVotes Read function with args
getSelectedReviewers  Read function with args
getVotingEnded  Read function with args
isApproved  Read function with args
revealVote  Write function with args
reviewers Read function with args
submissions Read function with args
submitData  Write function with args
