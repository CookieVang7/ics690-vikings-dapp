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
        //address[] votersForCandidate;
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
    uint public totalVotes;
    uint private totalMVCs;

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
        addCandidate("Bill Belichick", temp2); // id: 1
        addCandidate("Mike Vrabel", temp3); // id: 2
        addCandidate("Brandon Staley", temp4); // id: 3
        addCandidate("Frank Reich", temp5); // id: 4

        address temp6 = 0x0022872cD7Dc3E7eA18242D815B85bF972df29b7;
        address temp7 = 0x29903d7E00703607844FCb5D1492B0AFC016E9bf;
        address temp8 = 0x8c7Fe6BdEa2e1a76C80dCB75BC0086f96dF550c2;
        address temp9 = 0x3f53E1a5c3c56bBd23d97890A28f9ce1c05ee563;
        address temp10 = 0x23cCEB31284c9b13361dfE36447Ece97e38Cc887;
        mockVote(temp6, 1);
        mockVote(temp7, 1);
        mockVote(temp8, 2);
        mockVote(temp9, 2);
        mockVote(temp10, 3);

        contractAddress = address(this);
    }

    function mockVote(address voterAddress, uint candidateId) private {
        voters[voterAddress] = true;
        Candidate storage candidate = candidates[candidateId];
        candidate.voteCount++;
        totalVotes++;
    }

    function addCandidate (string memory _name, address owner) private {
        candidatesCount ++;

        candidates[candidatesCount] = Candidate(candidatesCount, _name, 1, owner);

        voters[owner] = true;
        totalMVCs += 4;
        totalVotes++;
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        require(mvcToken.mvcBalance(msg.sender) >= 2, "Insufficient MVC tokens to vote");

        mvcToken.transfer(msg.sender,contractAddress,2);
        skolFaithfulInstance.mvcTransaction(msg.sender,2);
        totalMVCs += 2;
        totalVotes++;

        // record that voter has voted
        voters[msg.sender] = true;

        Candidate storage candidate = candidates[_candidateId];
        candidate.voteCount++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }

    // 26 total MVCs
    // function finishVoting() public {
    //     address temp1 = 0xf220d553fbbC28b6f381CbB2bE99D59De42d2F84;
    //     if (voters[temp1] == true){

    //     }
    // }
}