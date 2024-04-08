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
    uint public totalMVCs;

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    address public contractAddress;
    function getContractMVCs() public view returns (uint256) {
        return mvcToken.mvcBalance(contractAddress);
    }

    constructor (address mvcTokenAddress, address skolFaithfulAddress) {
        mvcToken = MVCTokenContract.MVCToken(mvcTokenAddress);
        skolFaithfulInstance = SkolFaithfulContract.SkolFaithful(skolFaithfulAddress);
        contractAddress = address(this);

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
    }

    function mockVote(address voterAddress, uint candidateId) private {
        voters[voterAddress] = true;
        Candidate storage candidate = candidates[candidateId];
        candidate.voteCount++;
        totalVotes++;

        mvcToken.transfer(voterAddress,contractAddress,2);
        skolFaithfulInstance.mvcTransaction(voterAddress,2);
    }

    function addCandidate (string memory _name, address owner) private {
        candidatesCount ++;

        candidates[candidatesCount] = Candidate(candidatesCount, _name, 1, owner);

        voters[owner] = true;
        totalMVCs += 4;
        totalVotes++;

        mvcToken.transfer(owner,contractAddress,4);
        skolFaithfulInstance.mvcTransaction(owner,4);
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

    // 28 total MVCs
    // Each account gets 1 MVC -> 28-10 = 18
    // Account 2 gets 30% of 18 -> 18-6 = 12
    // Account 3 gets 25% of 12 -> 12-3 = 9
    // Account 4 gets 20% of 9 -> 9-2 = 7
    // Account 5 gets 15% of 7 -> 7-2 = 5
    // 5 remaining MVC tokens are burned

    // Account 1,6,7,8,9,10 each get 1 MVC
    // Account 2 gets 6
    // Account 3 gets 3
    // Account 4 gets 2
    // Account 5 gets 2
    function finishVoting() public {
        address temp1 = 0xf220d553fbbC28b6f381CbB2bE99D59De42d2F84;
        address temp2 = 0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa;
        address temp3 = 0x48f84a00F895be17BD4Fa9e0731c7b39eAcd6FBe;
        address temp4 = 0xCF16fe704d4b01ecDD98A41af04B92008D2a32CC;
        address temp5 = 0x709E646fc789ec4b3D093C8871f66640E9c60616;
        address temp6 = 0x0022872cD7Dc3E7eA18242D815B85bF972df29b7;
        address temp7 = 0x29903d7E00703607844FCb5D1492B0AFC016E9bf;
        address temp8 = 0x8c7Fe6BdEa2e1a76C80dCB75BC0086f96dF550c2;
        address temp9 = 0x3f53E1a5c3c56bBd23d97890A28f9ce1c05ee563;
        address temp10 = 0x23cCEB31284c9b13361dfE36447Ece97e38Cc887;

        mvcToken.transfer(contractAddress,temp1,1);
        mvcToken.transfer(contractAddress,temp2,6);
        mvcToken.transfer(contractAddress,temp3,3);
        mvcToken.transfer(contractAddress,temp4,2);
        mvcToken.transfer(contractAddress,temp5,2);
        mvcToken.transfer(contractAddress,temp6,1);
        mvcToken.transfer(contractAddress,temp7,1);
        mvcToken.transfer(contractAddress,temp8,1);
        mvcToken.transfer(contractAddress,temp9,1);
        mvcToken.transfer(contractAddress,temp10,1);

        skolFaithfulInstance.mvcReward(temp1,1);
        skolFaithfulInstance.mvcReward(temp2,6);
        skolFaithfulInstance.mvcReward(temp3,3);
        skolFaithfulInstance.mvcReward(temp4,2);
        skolFaithfulInstance.mvcReward(temp5,2);
        skolFaithfulInstance.mvcReward(temp6,1);
        skolFaithfulInstance.mvcReward(temp7,1);
        skolFaithfulInstance.mvcReward(temp8,1);
        skolFaithfulInstance.mvcReward(temp9,1);
        skolFaithfulInstance.mvcReward(temp10,1);

        skolFaithfulInstance.repReward(temp1,1);
        skolFaithfulInstance.repReward(temp2,5);
        skolFaithfulInstance.repReward(temp3,5);
        skolFaithfulInstance.repReward(temp4,4);
        skolFaithfulInstance.repReward(temp5,4);
        skolFaithfulInstance.repReward(temp6,1);
        skolFaithfulInstance.repReward(temp7,1);
        skolFaithfulInstance.repReward(temp8,1);
        skolFaithfulInstance.repReward(temp9,1);

        for (uint i=0;i<21;i++){
            totalVotes--;
        }
    }
}