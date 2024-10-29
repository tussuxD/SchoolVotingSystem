// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract SchoolVotingSystem {
    address public admin;
    IERC20 public rewardToken;
    uint256 public rewardAmount;

    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }
    
    struct Voter {
        bool hasVoted;
        uint256 votedCandidateId;
        bool isRegistered;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint256 public candidatesCount;

    event CandidateAdded(uint256 candidateId, string name);
    event VoterRegistered(address voter);
    event VoteCast(address voter, uint256 candidateId);
    event RewardDistributed(address voter, uint256 amount);
    event VoterCheck(address voter, bool isRegistered); //for debugging purpose

    // actions to admin only
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not an admin");
        _;
    }

    constructor(address _rewardToken, uint256 _rewardAmount) {
        admin = msg.sender;
        rewardToken = IERC20(_rewardToken);
        rewardAmount = _rewardAmount;
    }

    // Admin function to add new candidates
    function addCandidate(string memory _name) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    // Admin function to register a voter
    function registerVoter(address _voter) public onlyAdmin {
        require(!voters[_voter].isRegistered, "Voter already registered");
        voters[_voter] = Voter(false, 0, true);
        emit VoterRegistered(_voter);
    }

    //check a voter's registration status
    function checkVoterStatus(address _voter) public view returns (bool) {
        return voters[_voter].isRegistered;
    }

    // Voting function
    function vote(uint256 _candidateId) public {
        require(voters[msg.sender].isRegistered, "Voter not registered");
        require(!voters[msg.sender].hasVoted, "Already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedCandidateId = _candidateId;

        candidates[_candidateId].voteCount++;

        rewardToken.transfer(msg.sender, rewardAmount);
        emit VoteCast(msg.sender, _candidateId);
        emit RewardDistributed(msg.sender, rewardAmount);
    }

    // Admin function to get vote count of a candidate
    function getVoteCount(uint256 _candidateId) public view returns (uint256) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        return candidates[_candidateId].voteCount;
    }

    // Admin function to change reward amount
    function setRewardAmount(uint256 _newRewardAmount) public onlyAdmin {
        rewardAmount = _newRewardAmount;
    }
}
