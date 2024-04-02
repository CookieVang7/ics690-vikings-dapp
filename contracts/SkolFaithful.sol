// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./safemath.sol";
import "./MVCToken.sol" as MVCTokenContract;
import "./REPToken.sol" as REPTokenContract;

// to interact with a deployed instance of this contract after running command "truffle console":
// SkolFaithful.deployed().then(function(instance) {app = instance})

// address of contract: '0x55177A98E75ef8bd8A4B0a4dd432C85a4A3659a8'

contract SkolFaithful {
    using SafeMath for uint;
    MVCTokenContract.MVCToken public mvcToken;

    struct Member {
        address owner;
        uint mvcs;
        uint repTokens;
    }

    // Members of the DAO, currently hidden to users
    mapping(address => Member) private skolNation;

    // can reference with: app.clientUser(), app.skolNationCount().toNumber()
    uint public skolNationCount;
    Member public clientUser;

    constructor (MVCTokenContract.MVCToken myMvcToken) {
        address temp1 = 0xf220d553fbbC28b6f381CbB2bE99D59De42d2F84;
        address temp2 = 0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa;
        address temp3 = 0x48f84a00F895be17BD4Fa9e0731c7b39eAcd6FBe;
        address temp4 = 0xCF16fe704d4b01ecDD98A41af04B92008D2a32CC;
        address temp5 = 0x709E646fc789ec4b3D093C8871f66640E9c60616;
        addMember(temp1); // Bill Belichick
        addMember(temp2); // Mike Vrabel
        addMember(temp3); // Brandon Staley
        addMember(temp4); // Frank Reich
        addMember(temp5);

        mvcToken = myMvcToken;
    }

    // Adding members to the skolNation map giving them initial values of 4 MVCs and 0 REP tokens
    function addMember(address owner) private {
        skolNationCount = skolNationCount.add(1);
        skolNation[owner] = Member(owner,0,0);

        mvcToken.mint(owner,4);
    }

    event newDAOMember(address newUser);

    // function for a new user to join the DAO
    function joinDAO(address owner) public payable {
        uint ethAmount = 2;
        require(msg.value == ethAmount.toWei(), 'Insufficient funds provided');

        addMember(owner);

        emit newDAOMember(owner);
    }

    // TODO: condense SkolFaithful and CoachVotingMechanism into a voting contract with the redistribution mechanism
}