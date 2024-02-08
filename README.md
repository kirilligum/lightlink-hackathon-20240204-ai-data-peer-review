# AI data peer review

lightlink hackathon 20240204 https://youtu.be/xgpdjpQqGkY

High-quality data is the biggest driver and competitive advantage in AI. Inspired by peer-reviewed scientific publishing, I have built a Web3 peer-review system for creating high-quality datasets that focus on teaching AI how to think. Here is how it works:
1. Authors and reviewers are specified during the creation of the contract.
2. Reviewers specify their areas of expertise.
3. An author submits a data object comprising instructions and a response.
4. The contract shuffles the order of reviewers using a quantum random number generator, compares reviewers' preferences with the data object, and selects the best reviewers for that particular data object based on keyword appearance frequency.
5. Reviewers examine the data object and, in a blind vote (commit-reveal scheme), decide if the data object is of high enough quality to be accepted.
All the data is on-chain, creating transparency for AI and a way for authors and reviewers to be compensated and to grow their reputation in an open manner. The contract has undergone extensive testing.

<!--START_SECTION:update_image-->
<!--END_SECTION:update_image-->

## Motivation

With the introduction of ChatGPT and instruction-tuning (https://openai.com/research/instruction-following), large language models (LLMs) have transitioned from being a hobby of highly technical individuals to an essential tool for almost everyone in nearly any knowledge-based task. Instruction-tuning demonstrated that the ROI on creating high-quality data is 10-100x that of spending resources on GPUs. With increasingly sophisticated LLMs, shallow knowledge data labelers are being replaced by LLMs, creating a demand for deeper knowledge labelers. In addition, the "Textbooks Are All You Need" paper (https://arxiv.org/abs/2306.11644) showed that including only high-quality data not only reduces the dataset size but also improves benchmarks.

Currently, top-level data labeling companies like ScaleAI and SurgeHQ hire experts to label data. This approach is not scalable and has historically not worked well. Bureaucracy, technical cost, international payments, and bias are some of the problems. The system that works well is academic publishing — a peer-review system for top-level experts to collaborate. Even though the academic system is already decentralized by means of libraries acting as a decentralized ledger for publications, it is quite inefficient — reviewers don't get paid, and journals charge $1000 to publish. Furthermore, data creation for AI needs to work faster and with smaller text amounts, like a chat interface. Web3, with its microtransaction capabilities, open-tech nature, inclusiveness, and trustworthiness, is a natural solution.

## User flow

Our decentralized peer-review system works as follows:

1. An entity that wants high-quality data launches a contract and specifies a list of reviewers and authors.
1. Reviewers submit keywords that indicate their area of expertise.
1. Authors submit a data object that can be an instruction and response.
1. The contract finds the best-fitting reviewers by comparing the data object with the reviewers' keywords. During this process, the order in the list of reviewers is randomized using a quantum random number generator so that the same reviewers don't get picked all the time just because they are first in the original list.
1. Reviewers vote using a commit-reveal blind voting mechanism.
1. The data object is accepted or rejected based on a Schelling point mechanism.

## Features

- On-chain submission and approval by reviewers of data focused on teaching and aligning AI.
- Quantum random number generator to avoid bias in picking reviewers.
- On-chain commit-reveal for blind voting.
- On-chain scoring of text similarity to reviewers' preferences.


## Future features
- A rating system for reviewers and authors.
- Data attribution - get paid more for more impactful data.
- An on-chain LLM (already in existence) for picking reviewers.


## tech stack

- Lightlin Enterprise Mode helps to remove the hurdles of gas fees and scale the system. This is crucial because the peer-review system requires a lot of interactions.
- BlockScout for observing on-chain and managing transactions using tags.
- Quantum Random Number Generator by API3 (bounty) for shuffling reviewers to avoid selection bias.
- Remix and Forge Test for Solidity contract development and testing.


## General requirements of the hackathon

1. Enabled Enterprise mode on testnet for my contract https://pegasus.lightlink.io/tx/0x2523b1b16717699d33ec2c16903025f8ef5b15384c835f24ceb8c95df8494f4d
2. Deployed (https://pegasus.lightlink.io/address/0x573d1A911A4355bDd26ecFFc0E24E27a5105c121)  on Lightlink testnet Pegasus (with enterprise mode)
3. the whole project is from scratch
4. Solo Developer
5. Took on the "Best Use of API3 QRNG" challenge by API3 — I randomized peer-reviewers to avoid bias. For BlockBounty, I added the random generating EOA to my whitelist, used private tags, and submitted a public tag "data-labeling".


## Deploying and interacting on Remix

![contract sequence](./PeerReview_sequence.mmd.svg)

https://gist.github.com/kirilligum/182aa280b7f1a2ef6e7ff4e75961934f

1. go to remix https://remix.ethereum.org/#version=soljson-v0.8.9+commit.e5eed63a.js&optimize=false&runs=200&gist= and create a blank workspace
1. Click on Load from Gist and enter https://gist.github.com/kirilligum/182aa280b7f1a2ef6e7ff4e75961934f
1. select PeerReview.sol file at gist-182aa280b7f1a2ef6e7ff4e75961934f/github/kirilligum/lightlink-hackathon-20240204-ai-data-peer-review/src/PeerReview.sol
1. Compile
1. create wallets for 1+ authors and 3+ reviewers (need at least 3 reviewers for voting)
    1. `cast wallet new-mnemonic`
    1. import the wallets to metamask
1. Deploy
    1. set Environment to be Injected Provider so that you can interact with metamask. I used Pegasus lighlink test network because they allow gassless transactions
    1. use your owner account on metamask to deploy
    1. list authors. using anvil/harhat addresses as an example: ["0x70997970C51812dc3A010C7d01b50e0d17dc79C8", "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"] (you should use the addresses that you created)
    1. list reviewers. using anvil/harhat addresses as an example: [ "0x90F79bf6EB2c4f870365E785982E1f101E93b906", "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65", "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc", "0x976EA74026E726554dB657fA54763abd0C3a0aa9"] (you should use the addresses that you created)
    1. _AIRNODERRP is 0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd as described in api3 quantum random generator doc https://docs.api3.org/guides/qrng/qrng-remix/
1. `addKeywords` for the reviewers.
    1. switch to the first reviewer account (0x90F79bf6EB2c4f870365E785982E1f101E93b906) and submit a string of
    - keywordsReviewer1 ["gasless","blockchain"]
    - keywordsReviewer3 ["transactions"]
    - keywordsReviewer4 ["fees"]
    - we skip keywordsReviewer2
1. `submitData`
    - _question: "why do we need gasless transactions?"
    - _response: "We need gasless transactions to make blockchain easier to use and access for everyone, especially newcomers, by removing the need for upfront crypto and managing fees. This improves user experience and potentially helps scale the technology. However, it introduces some centralization concerns."
1. set up quantum random generator accorig to https://docs.api3.org/guides/qrng/qrng-remix/
    1. `setRequestParameters`
    1. send money to the sponsor wallet so it can post the random number. keep in mind that you generate the sponsor wallet depending on this contract address
    1. `makeRequestUint256`
    1. wait for the random generator server to post a random number. check that `_qrngUint256 ` changed from 0 to a random number
    1. assign that random number to the current submission `assignQrndSeed`
1. run `findReviewers` . it will:
    - shuffles reviewers so that when we iterate them, the order changes. sometimes many reviewers will have the same match score, in that case shuffling makes sure that reviewer4s that are earlier in the original list don't have a preference of being picked
    - pick the best reviewers for the data
        - create a match score based on how many of the reviewr's keywords are in the question and response
        - using a shorter version of min-heap, find 3 reviewers with highest matches between reviewer's keywords and the data object
1. switch to each of the reviewer and `commitVote`
1. mark `endVoting`
1. `revealVote`
1. `submission.isApproved ` shows if the submission is approved
1. an author can submit a new submission

