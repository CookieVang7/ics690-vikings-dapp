// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./safemath.sol";

// This contract is where proposals for head coach candidates are sent to and where votes are cast for a head coach
// It also controls the distribution of MVCs and REP tokens when voting finishes
contract CoachVotingMechanism {
    // some coaches already proposed
    // some coaches free to make a proposal for

    using SafeMath for uint;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
        address ownerAddress;
        address[] votersForCandidate;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) private haveVoted;
    mapping(address => bool) private hasProposed;
    uint public candidateCount;
    uint private totalEther;

    event votedEvent (
        uint indexed _candidateId
    );

    event ProposalReceived(address sender, string candidateName, uint amount);

    constructor () {
        address temp2 = 0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa;
        address temp3 = 0x48f84a00F895be17BD4Fa9e0731c7b39eAcd6FBe;
        address temp4 = 0xCF16fe704d4b01ecDD98A41af04B92008D2a32CC;
        address temp5 = 0x709E646fc789ec4b3D093C8871f66640E9c60616;
        addCandidate("Bill Belichick", temp2);
        addCandidate("Mike Vrabel", temp3);
        addCandidate("Brandon Staley", temp4);
        addCandidate("Frank Reich", temp5);
    }

    // adds a candidate to the list of candidates
    function addCandidate(string memory candidateName, address owner) private {
        require(!duplicateCandidateCheck(candidateName), 'Candidate already in contention for voting');

        candidateCount = candidateCount.add(1);
        hasProposed[owner] = true;
        address[] memory votersForCandidate;
        candidates[candidateCount] = Candidate(candidateCount,candidateName,1,owner,votersForCandidate);
    }

    function duplicateCandidateCheck(string memory candidateName) private view returns (bool) {
        bool output = false;
        for (uint i=1; i<=candidateCount; i++){
            Candidate memory temp = candidates[i];
            if (keccak256(abi.encodePacked(temp.name)) == keccak256(abi.encodePacked(candidateName))){
                output = true;
                break;
            }
        }
        return output;
    }

    function voteForCandidate(uint candidateId, address voterAddress) public payable {
        require(!haveVoted[msg.sender], 'User account has already voted');
        uint ethAmount = 2;
        require(msg.value == ethAmount.toWei(), 'Insufficient funds provided');
        require(candidateId > 0 && candidateId <= candidateCount);

        haveVoted[msg.sender] = true;
        candidates[candidateId].voteCount = candidates[candidateId].voteCount.add(1);
        candidates[candidateId].votersForCandidate.push(voterAddress);
        
        emit votedEvent(candidateId);
    }

    function receiveCandidateProposal(string memory candidateName, address owner) public payable {
        require(!hasProposed[msg.sender], 'User account has already made a proposal');
        uint ethAmount = 4;
        require(msg.value == ethAmount.toWei(), 'Insufficient funds provided');

        totalEther = totalEther.add(msg.value);
        emit ProposalReceived(msg.sender, candidateName, msg.value);

        addCandidate(candidateName, owner);        
    }
}