# AI data peer review

lightlink hackathon 20240204


High-quality data is the biggest driver and competitive advantage in AI. Inspired by peer-reviewed scientific publishing, I have built a Web3 peer-review system for creating high-quality datasets that focus on teaching AI how to think. Here is how it works:
1. Authors and reviewers are specified during the creation of the contract.
2. Reviewers specify their areas of expertise.
3. An author submits a data object comprising instructions and a response.
4. The contract shuffles the order of reviewers using a quantum random number generator, compares reviewers' preferences with the data object, and selects the best reviewers for that particular data object based on keyword appearance frequency.
5. Reviewers examine the data object and, in a blind vote (commit-reveal scheme), decide if the data object is of high enough quality to be accepted.
All the data is on-chain, creating transparency for AI and a way for authors and reviewers to be compensated and to grow their reputation in an open manner. The contract has undergone extensive testing.






## Description

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


