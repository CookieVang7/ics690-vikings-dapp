// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./safemath.sol";
import "./MVCToken.sol" as MVCTokenContract;
//import "./REPToken.sol" as REPTokenContract;

// to interact with a deployed instance of this contract after running command "truffle console":
// SkolFaithful.deployed().then(function(instance) {app = instance})
// app.skolNation(0).then(function(c) {candidate=c})
// web3.eth.getAccounts().then(function(ugh) {accounts=ugh})
// ugh.skolNation(accounts[0]).then(function(c) {can=c})

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
    mapping(address => Member) public skolNation;

    // can reference with: app.clientUser(), app.skolNationCount().toNumber()
    uint public skolNationCount;

    constructor (address mvcTokenAddress) {
        mvcToken = MVCTokenContract.MVCToken(mvcTokenAddress);

        // have made head coach proposals
        address temp2 = 0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa;
        address temp3 = 0x48f84a00F895be17BD4Fa9e0731c7b39eAcd6FBe;
        address temp4 = 0xCF16fe704d4b01ecDD98A41af04B92008D2a32CC;
        address temp5 = 0x709E646fc789ec4b3D093C8871f66640E9c60616;
        address temp6 = 0x0022872cD7Dc3E7eA18242D815B85bF972df29b7;
        addMember(temp2,10); // Bill Belichick
        addMember(temp3,9); // Mike Vrabel
        addMember(temp4,8); // Brandon Staley
        addMember(temp5,7); // Frank Reich
        addMember(temp6,6); // Mike Zimmer

        // voters
        address temp7 = 0x29903d7E00703607844FCb5D1492B0AFC016E9bf;
        address temp8 = 0x8c7Fe6BdEa2e1a76C80dCB75BC0086f96dF550c2;
        address temp9 = 0x3f53E1a5c3c56bBd23d97890A28f9ce1c05ee563;
        address temp10 = 0x23cCEB31284c9b13361dfE36447Ece97e38Cc887;
        addMember(temp7, 5);
        addMember(temp8, 4);
        addMember(temp9, 3);
        addMember(temp10, 1);

        // voting demo
        address temp1 = 0xf220d553fbbC28b6f381CbB2bE99D59De42d2F84;
        addMember(temp1, 4);

        //repToken = myRepToken;
    }

    // Adding members to the skolNation map giving them initial values of 4 MVCs and 0 REP tokens
    function addMember(address owner, uint mvcAmount) private {
        skolNationCount = skolNationCount.add(1);
        skolNation[owner] = Member(owner,mvcAmount,0);

        // minting mvcAmount of MVCs and assigning it to the account
        mvcToken.mint(owner,mvcAmount);
    }

    function mvcTransaction(address owner, uint amount) public {
        // Ensure that the owner has enough MVC tokens to subtract
        require(skolNation[owner].mvcs >= amount, "Insufficient MVC tokens balance");

        // Subtract the specified amount of MVC tokens from the owner's balance
        skolNation[owner].mvcs = skolNation[owner].mvcs.sub(amount);
    }

    // event newDAOMember(address newUser);

    // // function for a new user to join the DAO
    // function joinDAO(address owner) public payable {
    //     uint ethAmount = 2; // costing 2 eth to join the dao
    //     require(msg.value == ethAmount.toWei(), 'Insufficient funds provided');

    //     addMember(owner,4);

    //     emit newDAOMember(owner);
    // }

    // TODO: condense SkolFaithful and CoachVotingMechanism into a voting contract with the redistribution mechanism
}