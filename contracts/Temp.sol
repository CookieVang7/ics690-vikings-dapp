// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./safemath.sol";
import "./MVCToken.sol" as MVCTokenContract;
//import "./SkolFaithful.sol";

// This contract is where proposals for head coach candidates are sent to and where votes are cast for a head coach
// It also controls the distribution of MVCs and REP tokens when voting finishes
contract CoachVotingMechanism {
    // some coaches already proposed
    // some coaches free to make a proposal for

    MVCTokenContract.MVCToken public mvcToken;

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
    mapping(address => bool) private hasProposed;
    uint public candidateCount;
    //uint private totalEther;
    //uint private totalMVCS;

    event votedEvent (
        uint indexed _candidateId
    );

    event ProposalReceived(address sender, string candidateName, uint amount);

    address public contractAddress;

    constructor (MVCTokenContract.MVCToken myMvcToken) {
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
        mvcToken = myMvcToken;
    }

    // adds a candidate to the map of candidates
    // checks for candidates with the duplicateCandidateCheck helper function
    // adds owner of candidate proposal to hasProposed map which is checked so an owner can't make more than 1 proposal 
    function addCandidate(string memory candidateName, address owner) private {
        //require(!duplicateCandidateCheck(candidateName), 'Candidate already in contention for voting');

        candidateCount = candidateCount.add(1);
        hasProposed[owner] = true;
        haveVoted[owner] = true;
        address[] memory votersForCandidate;
        candidates[candidateCount] = Candidate(candidateCount,candidateName,1,owner,votersForCandidate);
    }

    // helper function to check if incoming candidate is already proposed by someone else
    // function duplicateCandidateCheck(string memory candidateName) private view returns (bool) {
    //     bool output = false;
    //     for (uint i=1; i<=candidateCount; i++){
    //         Candidate memory temp = candidates[i];
    //         if (keccak256(abi.encodePacked(temp.name)) == keccak256(abi.encodePacked(candidateName))){
    //             output = true;
    //             break;
    //         }
    //     }
    //     return output;
    // }

    // user uses this function to vote for a coach candidate
    // makes sure user hasn't voted already and provides sufficient eth (costs 2mvcs/eth to vote)
    // increments votes for candidate and adds voter's address to array field in Candidate struct for potential redistribution
    // emits votedEvent event
    // OVERSIGHT - overlooked the separation of my DAO'S currency MVCs vs eth
    // function voteForCandidate(uint candidateId, address voterAddress) public payable {
    //     require(!haveVoted[msg.sender], 'User account has already voted');
    //     uint ethAmount = 2;
    //     require(msg.value == ethAmount.toWei(), 'Insufficient funds provided');
    //     require(candidateId > 0 && candidateId <= candidateCount);

    //     haveVoted[msg.sender] = true;
    //     candidates[candidateId].voteCount = candidates[candidateId].voteCount.add(1);
    //     candidates[candidateId].votersForCandidate.push(voterAddress);
        
    //     emit votedEvent(candidateId);
    // }
    function voteForCandidate(uint candidateId, address voterAddress) public payable {
        require(!haveVoted[msg.sender], 'User account has already voted');
        require(!haveVoted[voterAddress], 'User address has already voted');
        require(mvcToken.balanceOf(msg.sender) >= 2, "Insufficient MVC tokens to vote");
        require(candidateId > 0 && candidateId <= candidateCount);

        haveVoted[msg.sender] = true;
        candidates[candidateId].voteCount = candidates[candidateId].voteCount.add(1);
        candidates[candidateId].votersForCandidate.push(voterAddress);

        emit votedEvent(candidateId);
    }

    // user uses this function to submit a proposal for a new coach candidate
    // checks that sufficient eth is provided (4eth) and that user hasn't already made a proposal
    // adds ether to totalEther value which will be distributed after the voting has ended
    // function receiveCandidateProposal(string memory candidateName, address owner) public payable {
    //     require(!hasProposed[msg.sender], 'User account has already made a proposal');
    //     uint ethAmount = 4;
    //     require(msg.value == ethAmount.toWei(), 'Insufficient funds provided');

    //     totalEther = totalEther.add(msg.value);
    //     emit ProposalReceived(msg.sender, candidateName, msg.value);

    //     addCandidate(candidateName, owner);        
    // }

    // ChatGPT generated function that takes the map of candidates and returns an array of candidates coming top 5 in voting
    // index 0 candidate has most votes, index 4 candidate has least votes out of the top 5
    // function getPodium() private view returns (Candidate[5] memory) {
    //     Candidate[5] memory podium;
        
    //     // Initialize an array to store the top 5 candidates
    //     for (uint i = 0; i < 5; i++) {
    //         uint maxVotes = 0;
    //         uint maxIndex = 0;
            
    //         // Find the candidate with the maximum votes
    //         for (uint j = 1; j <= candidateCount; j++) {
    //             if (candidates[j].voteCount > maxVotes) {
    //                 bool isAlreadyInTop = false;
    //                 for(uint k = 0; k < i; k++) {
    //                     if(candidates[j].id == podium[k].id) {
    //                         isAlreadyInTop = true;
    //                         break;
    //                     }
    //                 }
    //                 if(!isAlreadyInTop) {
    //                     maxVotes = candidates[j].voteCount;
    //                     maxIndex = j;
    //                 }
    //             }
    //         }
            
    //         // Add the candidate with the maximum votes to the podium array
    //         podium[i] = candidates[maxIndex];
    //     }
        
    //     return podium;
    // }


    // bool public doneVoting = false;
    // function distributeMVCsAfterVoting(Candidate[] memory topFive) private {
    //     if (doneVoting) {
    //         //Candidate[] topFive = getPodium();

    //         for (uint i=0; i<topFive.length; i++){ // rule 1
    //             for (uint j=0; j<topFive[i].votersForCandidate.length; j++){
    //                 address payable recipient = payable(topFive[i].votersForCandidate[j]);
    //                 sendMVC(recipient, contractAddress, 1 ether);
    //             }
    //             totalEther = totalEther.sub(topFive[i].votersForCandidate.length);
    //         }

    //         uint conversion = 10;
    //         uint initialPercent = 30;

    //         for (uint k=0; k<topFive.length; k++){ // rules 2-6
    //             uint percentage = initialPercent - k * 5;
    //             uint amount = (totalEther*percentage/100)*conversion/100;

    //             address payable recipient2 = payable(topFive[k].ownerAddress);
    //             sendMVC(recipient2, contractAddress, amount);
    //         }
    //     }
    // }

    // function sendMVC(address payable _to, address _from, uint amount) public payable {
    //     require(msg.sender == _from, "Only the specified sender can call this function");
    //     require(address(this).balance >= amount, "Insufficient balance in the contract");

    //     _to.transfer(amount);
    // }

    // function awardRepTokens(address _memberAddress, uint _tokens) external {
    //     uint totalMembers = skolFaithful.getMembers().length;

    //     for (uint i=0; i<totalMembers; i++){
    //         SkolFaithful.Member memory member = skolFaithful.getMemberAtIndex(i);

    //         if (member.owner == _memberAddress){
    //             skolFaithful.updateRepTokens(i, _tokens);
    //             return;
    //         }
    //     }
    // }
}