// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// to interact with a deployed instance of this contract after running command "truffle console":
// SkolFaithful.deployed().then(function(instance) {app = instance})

// address of contract: '0x55177A98E75ef8bd8A4B0a4dd432C85a4A3659a8'

contract SkolFaithful {

    string public candidate;

    constructor () {
        candidate = "Bill Belichick";
    }
}