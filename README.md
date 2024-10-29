
---

# School Voting System

## Overview

The **School Voting System** is a decentralized voting platform designed to facilitate voting in a school environment. This system allows candidates to be added by an admin, voters to register, and for votes to be cast securely. Voters are rewarded with ERC20 tokens for participating in the voting process.

## Contracts

### 1. **SchoolVotingSystem**

This contract manages the voting process, including candidate registration, voter management, and vote casting. It requires an ERC20 token contract for rewarding voters.

#### Key Features
- **Add Candidates:** Admin can add candidates to the voting system.
- **Register Voters:** Admin can register voters.
- **Vote Casting:** Registered voters can cast their votes for candidates.
- **Rewards:** Voters receive a specified amount of reward tokens for each vote they cast.
- **Vote Count Retrieval:** Admin can view the number of votes each candidate has received.
- **Change Reward Amount:** Admin can change the reward amount given to voters.

#### Events
- `CandidateAdded`: Emitted when a new candidate is added.
- `VoterRegistered`: Emitted when a new voter is registered.
- `VoteCast`: Emitted when a vote is cast.
- `RewardDistributed`: Emitted when a reward is distributed to a voter.
- `VoterCheck`: Emitted to check a voter's registration status (for debugging).

### 2. **RewardToken**

This contract is an ERC20 token that serves as the reward currency for voters. It can be deployed before the **SchoolVotingSystem** contract and its address must be passed to the voting system.

#### Features
- Standard ERC20 token implementation with minting capabilities.

## Deployment Instructions

1. **Deploy the RewardToken Contract:**
   - Use the following command to deploy the `RewardToken` contract:
   ```solidity
   const rewardToken = await RewardToken.deploy(initialSupply);
   ```
   - Note down the deployed contract address for use in the next step.

2. **Deploy the SchoolVotingSystem Contract:**
   - Pass the address of the deployed `RewardToken` contract and the desired reward amount to the constructor of the `SchoolVotingSystem`:
   ```solidity
   const schoolVotingSystem = await SchoolVotingSystem.deploy(rewardToken.address, rewardAmount);
   ```

### Example Deployment Script (JavaScript)

```javascript
const RewardToken = artifacts.require("RewardToken");
const SchoolVotingSystem = artifacts.require("SchoolVotingSystem");

module.exports = async function (deployer) {
    // Step 1: Deploy RewardToken
    const initialSupply = web3.utils.toWei("1000000", "ether"); // 1 million tokens
    await deployer.deploy(RewardToken, initialSupply);
    const rewardTokenInstance = await RewardToken.deployed();

    // Step 2: Deploy SchoolVotingSystem with the address of the RewardToken
    const rewardAmount = web3.utils.toWei("10", "ether"); // Reward amount per vote
    await deployer.deploy(SchoolVotingSystem, rewardTokenInstance.address, rewardAmount);
};
```

## Usage

- After deployment, the admin can add candidates and register voters using the respective functions.
- Voters can check their registration status and cast their votes.
- The system will reward voters with the specified ERC20 tokens after each successful vote.

## Requirements

- Solidity version ^0.8.0
- OpenZeppelin contracts for ERC20 token implementation.

## License

This project is licensed under the MIT License.

---
