// an artifact that we can interact with
var SkolFaithful = artifacts.require("./SkolFaithful.sol");

// a directive to deploy the contract
module.exports = function(deployer) {
  deployer.deploy(SkolFaithful);
};
