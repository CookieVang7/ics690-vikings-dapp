// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./safemath.sol";

// to interact with a deployed instance of this contract after running command "truffle console":
// SkolFaithful.deployed().then(function(instance) {app = instance})

// address of contract: '0x55177A98E75ef8bd8A4B0a4dd432C85a4A3659a8'

contract SkolFaithful {
    using SafeMath for uint;

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

    constructor () {
        addMember(0xf220d553fbbC28b6f381CbB2bE99D59De42d2F84); // Bill Belichick
        addMember(0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa); // Mike Vrabel
        addMember(0x48f84a00F895be17BD4Fa9e0731c7b39eAcd6FBe);
        addMember(0xCF16fe704d4b01ecDD98A41af04B92008D2a32CC);
        addMember(0x709E646fc789ec4b3D093C8871f66640E9c60616);
    }

    // Adding members to the skolNation map giving them initial values of 4 MVCs and 0 REP tokens
    function addMember(address _owner) private {
        skolNationCount = skolNationCount.add(1);
        skolNation[_owner] = Member(_owner,4,0);
    }
}