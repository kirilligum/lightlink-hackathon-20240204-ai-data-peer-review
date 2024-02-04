const crypto = require('crypto');

// Function to generate a commit hash
function generateCommitHash(vote, secret) {
    const voteByte = vote ? '01' : '00'; // Representing boolean as byte
    const data = voteByte + secret.substring(2); // Remove '0x' from the secret before hashing
    const hash = crypto.createHash('sha256');
    hash.update(Buffer.from(data, 'hex'));
    return '0x' + hash.digest('hex');
}

// Function to generate examples
function generateExamples() {
    const examples = [];
    for (let i = 0; i < 3; i++) {
        const secret = '0x' + crypto.randomBytes(32).toString('hex');
        examples.push({ vote: true, secret, commitHash: generateCommitHash(true, secret) });
        examples.push({ vote: false, secret, commitHash: generateCommitHash(false, secret) });
    }
    return examples;
}

// Main execution
if (process.argv.length === 3) {
    const vote = process.argv[2].toLowerCase() === 'true';
    const secret = '0x' + crypto.randomBytes(32).toString('hex');
    console.log(`Vote: ${vote}, Secret: ${secret}, CommitHash: ${generateCommitHash(vote, secret)}`);
} else {
    console.log("Generated examples:");
    console.log(generateExamples());
}

