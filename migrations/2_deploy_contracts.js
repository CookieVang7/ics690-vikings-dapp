// an artifact that we can interact with
var Election2 = artifacts.require("./Election2.sol");
// var CoachVotingMechanism = artifacts.require("./CoachVotingMechanism.sol");
var MVCToken = artifacts.require("./MVCToken.sol");
// var REPToken = artifacts.require("./REPToken.sol");
var SkolFaithful = artifacts.require("./SkolFaithful.sol");

// a directive to deploy the contract
module.exports = function(deployer) {
  //deployer.deploy(Election2);
  // deployer.deploy(SkolFaithful);
  //deployer.deploy(CoachVotingMechanism);

  const mvcName = "MVC Token";
  const mvcSymbol = "MVC";

  const repName = "REP Token";
  const repSymbol = "REP";

  deployer.deploy(MVCToken,mvcName,mvcSymbol).then(function() {
    return deployer.deploy(SkolFaithful,MVCToken.address)
  }).then(function() {
    return deployer.deploy(Election2,MVCToken.address,SkolFaithful.address)
  });
  //deployer.deploy(SkolFaithful,mvcName,mvcSymbol);

  // deployer.deploy(MVCToken,mvcName,mvcSymbol).then(function() {
  //   return MVCToken.deployed();
  // }).then(function(mvcTokenInstance) {
  //   return deployer.deploy(CoachVotingMechanism, mvcTokenInstance.address);
  // })

  //deployer.deploy(CoachVotingMechanism);
  //deployer.deploy(REPToken,repName,repSymbol);
};
