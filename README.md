# lightlink-hackathon-20240204-ai-data-peer-review

## Description

With introduction of ChatGpt and instruction-tunning (https://openai.com/research/instruction-following), large language models (LLMs) became from a hobby of highly technical people to an essential tool for almost everyone in almost any knowledge-based task. Instruction-tunning showed that ROI on creating high-quality data is 10-100x of spending resources on GPU. With better-and-better LLMs, shellow knowledge data-labelers are getting replaced by LLMs creating a demand for deeper knowledge labelers. In addition to that, "Textbooks Are All You Need" https://arxiv.org/abs/2306.11644 paper showed that including only high quality data not only reduces the data set size but also improves benchmarks.
Currently, top-level data labeling companies like scaleAI and surgeHQ hire experts to label data. This is not scalable and historically didn't work. Beuarocracy, technical cost, international payments, bias are some of the problem. The system that is working well is academic punlishing -- a peer-review system for the top-level experts to collaborate. Eventhough the academic system is already decentralized by the means of libraries acting as a decentralized ledger for publication, it is quite inefficient -- reviewers don't get paid and journals charge $1000 to publish; furthermore, data-creation for AI needs to work faster with smaller text amount like chat interface. Web3 with its microtransactoin, open-tech nature, inclusiveness, and trust is a natural solution.


Your text is well-structured and presents a comprehensive overview of the proposed system. However, it contains some grammatical and typographical errors. Here's a revised version with corrections:

With the introduction of ChatGPT and instruction-tuning (https://openai.com/research/instruction-following), large language models (LLMs) have transitioned from being a hobby of highly technical individuals to an essential tool for almost everyone in nearly any knowledge-based task. Instruction-tuning demonstrated that the ROI on creating high-quality data is 10-100x that of spending resources on GPUs. With increasingly sophisticated LLMs, shallow knowledge data labelers are being replaced by LLMs, creating a demand for deeper knowledge labelers. In addition, the "Textbooks Are All You Need" paper (https://arxiv.org/abs/2306.11644) showed that including only high-quality data not only reduces the dataset size but also improves benchmarks.

Currently, top-level data labeling companies like ScaleAI and SurgeHQ hire experts to label data. This approach is not scalable and has historically not worked well. Bureaucracy, technical cost, international payments, and bias are some of the problems. The system that works well is academic publishing — a peer-review system for top-level experts to collaborate. Even though the academic system is already decentralized by means of libraries acting as a decentralized ledger for publication, it is quite inefficient — reviewers don't get paid, and journals charge $1000 to publish. Furthermore, data creation for AI needs to work faster and with smaller text amounts, like a chat interface. Web3, with its microtransaction capabilities, open-tech nature, inclusiveness, and trustworthiness, is a natural solution.

## User flow

Our decentralized peer-review system works as following:

1. An entity that wants the high quality data launches a contract and specifies a list of reviewers and authors
2. Reviewers submit keywords that show their area of expertise
3. Authors submits a data object that can be instruction and response
4. the contract finds best fitting reviewers based on comparing the data object with reviewers' keywords. during this process, the order in the list of reviewers is randomized using quantum random number generator so that the same reviewers don't get picked all the time just because they are first in the original list.
5. reviewers vote using a blind voting mechanism -- commite-reveal
6. the data object is accepted or rejected based on schielling point mechanism

## Features

- on-chain submition and aproval by reviewers of data that is focused on teaching and aligning AI
- Quantum random number generator to avoid bias
- on-chain comit-reveal for blind voting
- on-chain scoring of text similarity to reviewers preference

## Future features
- rating system for reviewers and authors
- data attribution - get paid more for more impactful data
- on-chain LLM (already exist) for picking reviewers

## tech stack

- **Lightlin enterprise mode** helps to remove the hurdles of gas fees and scale the system. this is crucial because the peer review system needs a lot of interactions
- **blockscout** for observing on-chain and managing txs using tags
- **quantum random number generator** by API3 (bounty) for shuffling reviewers as to avoid selection bias
- **remix**, **forge test** for solidity contract development and testing

## General requirements of the hackathon

1. Enabled Enterprise mode on testnet for my contract https://pegasus.lightlink.io/tx/0x2523b1b16717699d33ec2c16903025f8ef5b15384c835f24ceb8c95df8494f4d
2. Deployed (https://pegasus.lightlink.io/address/0x573d1A911A4355bDd26ecFFc0E24E27a5105c121)  on Lightlink testnet Pegasus (with enterprise mode)
3. the whole project is from scratch
4. Solo Developer
5. Took on "Best use of API3 QRNG" challenge by API3 -- I randomized peer-reviewers to avoid bias. For blockbounty, i added the random generating EOA to my withlist, used private tags, and submitted a public tag "data-labeling"


