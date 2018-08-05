var VoteProposal = artifacts.require("VoteProposal");

module.exports = function(deployer) {
  deployer.deploy(VoteProposal);
};