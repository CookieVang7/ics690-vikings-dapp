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
    mapping(address => bool) public haveVoted;
    uint public candidateCount;

    event votedEvent (
        uint indexed _candidateId
    );

    constructor () {
        address temp1 = 0xf220d553fbbC28b6f381CbB2bE99D59De42d2F84;
        address temp2 = 0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa;
        addCandidate("Bill Belichick", temp1);
        addCandidate("Mike Vrabel", temp2);
    }

    function addCandidate(string memory _candidateName, address owner) private {
        candidateCount = candidateCount.add(1);
        address[] memory votersForCandidate;
        candidates[candidateCount] = Candidate(candidateCount,_candidateName,0,owner,votersForCandidate);
    }

    function voteForCandidate(uint _candidateId, address voterAddress) public payable {
        require(!haveVoted[msg.sender]);
        uint ethAmount = 2;
        require(msg.value == ethAmount.toWei());
        require(_candidateId > 0 && _candidateId <= candidateCount);

        haveVoted[msg.sender] = true;
        candidates[_candidateId].voteCount = candidates[_candidateId].voteCount.add(1);
        candidates[_candidateId].votersForCandidate.push(voterAddress);
        
        emit votedEvent(_candidateId);
    }
}