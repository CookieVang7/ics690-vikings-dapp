// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

//import "./safemath.sol";
//import "./MVCToken.sol" as MVCTokenContract;

contract CoachVotingMechanism {
    //MVCTokenContract.MVCToken public mvcToken;

    //using SafeMath for uint;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
        address ownerAddress;
        address[] votersForCandidate;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public haveVoted;
    mapping(address => bool) private hasProposed;
    uint public candidateCount;

    event votedEvent (uint indexed _candidateId);
    event ProposalReceived(address sender, string candidateName, uint amount);
    address public contractAddress;

    constructor () {
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

    function addCandidate(string memory candidateName, address owner) private {
        //candidateCount = candidateCount.add(1);
        candidateCount++;
        hasProposed[owner] = true;
        haveVoted[owner] = true;
        address[] memory votersForCandidate;
        candidates[candidateCount] = Candidate(candidateCount,candidateName,1,owner,votersForCandidate);
    }

    function voteForCandidate(uint candidateId, address voterAddress) public payable {
        require(!haveVoted[voterAddress], 'User address has already voted');
        //require(mvcToken.balanceOf(msg.sender) >= 2, "Insufficient MVC tokens to vote");

        haveVoted[msg.sender] = true;
        // candidates[candidateId].voteCount = candidates[candidateId].voteCount.add(1);
        candidates[candidateId].voteCount++;
        candidates[candidateId].votersForCandidate.push(voterAddress);

        emit votedEvent(candidateId);
    }
}