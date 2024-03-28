// an artifact that we can interact with
var Election = artifacts.require("./Election.sol");
var CoachVotingMechanism = artifacts.require("./CoachVotingMechanism.sol");
var MVCToken = artifacts.require("./MVCToken.sol");
var REPToken = artifacts.require("./REPToken.sol");

// a directive to deploy the contract
module.exports = function(deployer) {
  deployer.deploy(Election);
  deployer.deploy(CoachVotingMechanism);

  const mvcName = "MVC Token";
  const mvcSymbol = "MVC";

  const repName = "REP Token";
  const repSymbol = "REP";

  deployer.deploy(MVCToken,mvcName,mvcSymbol);
  deployer.deploy(REPToken,repName,repSymbol);
};
