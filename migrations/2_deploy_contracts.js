// an artifact that we can interact with
var Election = artifacts.require("./Election.sol");
var CoachVotingMechanism = artifacts.require("./CoachVotingMechanism.sol");

// a directive to deploy the contract
module.exports = function(deployer) {
  deployer.deploy(Election);
  deployer.deploy(CoachVotingMechanism);
};
