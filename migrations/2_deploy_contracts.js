// an artifact that we can interact with
var Election2 = artifacts.require("./Election2.sol");
var MVCToken = artifacts.require("./MVCToken.sol");
var REPToken = artifacts.require("./REPToken.sol");
var SkolFaithful = artifacts.require("./SkolFaithful.sol");

// a directive to deploy the contract
module.exports = function(deployer) {
  const mvcName = "MVC Token";
  const mvcSymbol = "MVC";

  const repName = "REP Token";
  const repSymbol = "REP";

  deployer.deploy(MVCToken,mvcName,mvcSymbol).then(function() {
    return deployer.deploy(REPToken,repName,repSymbol);
  }).then(function() {
    return deployer.deploy(SkolFaithful,MVCToken.address,REPToken.address)
  }).then(function() {
    return deployer.deploy(Election2,MVCToken.address,SkolFaithful.address)
  });
};
