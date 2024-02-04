const crypto = require('crypto');

function generateCommitHash(vote, salt) {
 if (!salt) {
   salt = crypto.randomBytes(16); // Generates a random salt
 }

 // Combine the vote and salt
 const combined = vote.toString() + salt.toString('hex');

 // Create a SHA-256 hash
 const commitHash = crypto.createHash('sha256').update(combined).digest('hex');

 return { commitHash, salt: salt.toString('hex') };
}

// Loop for 3 examples
for (let i = 1; i <= 6; i++) {
 const vote = i % 2 === 0; // Alternate between true and false
 const { commitHash, salt } = generateCommitHash(vote);
 console.log(`Example ${i}:`);
 console.log("Vote:", vote);
 console.log("Commit Hash:", commitHash);
 console.log("Salt:", salt);
 console.log("--------------------");
}

