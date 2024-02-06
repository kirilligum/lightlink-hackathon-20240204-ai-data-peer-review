# Front End Layout Schema (Single Page)

## welcome
- **Text**: "Welcome to the Peer Review Platform"
- **Text**: "Authors and reviewers have been assigned during the contract creation process"
- **Text**: "Authors: {authors}"
- **Text**: "Reviewers: {reviewers}"

## Reviewers
- **Text**: "Reviewers: Update Your Keywords"
- **Form**: Keywords Update
  - Keywords (Textarea)
  - Button: "Update"

## Authors
- **Text**: "Authors: Submit Your Data Object"
- **Form**: Data Submission
  - Question (Input field)
  - Response (Textarea)
  - Button: "Submit"
  - Button: "find reviewers"

## Reviewers
- **Text**: "Reviewers: Review Assignments"
  - List of Assignments
    - Text: Question
    - Text: Response
    - Form: Review
      - vote+secret=>commitHash (Input field)
      - Button: "Submit Blind Vote"

## end vote
- Button: "end vote"

## Reviewers: Reveal
- **Form**: Reveal Your Vote
  - vote (Input field)
  - secret (Input field)
  - Button: "Submit"

## generate Decision
- **Text**: decision based on majority vote
    - Button: get decision

## decision

- **Text**: "Your Submissions"
  - List of Submissions with Status (Pending, Approved, Rejected)
