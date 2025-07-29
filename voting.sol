// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public admin;

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint _candidateIndex) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        candidates[_candidateIndex].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }

    function getCandidate(uint index) public view returns (string memory name, uint voteCount) {
        require(index < candidates.length, "Invalid index");
        Candidate storage c = candidates[index];
        return (c.name, c.voteCount);
    }

    function getWinner() public view returns (string memory winnerName, uint winnerVotes) {
        require(candidates.length > 0, "No candidates available");

        uint maxVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        return (candidates[winnerIndex].name, candidates[winnerIndex].voteCount);
    }

    // Accept plain Ether transfers
    receive() external payable {
        // Ether received without data
    }

    // Accept Ether with unknown function calls or data
    fallback() external payable {
        // Fallback function called
    }
}