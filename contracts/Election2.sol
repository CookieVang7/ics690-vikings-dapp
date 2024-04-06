// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./MVCToken.sol" as MVCTokenContract;
import "./SkolFaithful.sol" as SkolFaithfulContract;

contract Election2 {
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
        address ownerAddress;
        address[] votersForCandidate;
    }

    MVCTokenContract.MVCToken public mvcToken;
    SkolFaithfulContract.SkolFaithful public skolFaithfulInstance;

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    address public contractAddress;

    constructor (address mvcTokenAddress, address skolFaithfulAddress) {
        mvcToken = MVCTokenContract.MVCToken(mvcTokenAddress);
        skolFaithfulInstance = SkolFaithfulContract.SkolFaithful(skolFaithfulAddress);

        address temp2 = 0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa;
        address temp3 = 0x48f84a00F895be17BD4Fa9e0731c7b39eAcd6FBe;
        address temp4 = 0xCF16fe704d4b01ecDD98A41af04B92008D2a32CC;
        address temp5 = 0x709E646fc789ec4b3D093C8871f66640E9c60616;
        address temp6 = 0x0022872cD7Dc3E7eA18242D815B85bF972df29b7;
        addCandidate("Bill Belichick", temp2);
        addCandidate("Mike Vrabel", temp3);
        addCandidate("Brandon Staley", temp4);
        addCandidate("Frank Reich", temp5);
        addCandidate("Mike Zimmer", temp6);

        contractAddress = address(this);
    }

    function addCandidate (string memory _name, address owner) private {
        candidatesCount ++;
        address[] memory temp;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, owner, temp);
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        require(mvcToken.mvcBalance(msg.sender) >= 2, "Insufficient MVC tokens to vote");

        mvcToken.transfer(msg.sender,contractAddress,2);
        skolFaithfulInstance.mvcTransaction(msg.sender,2);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }
}