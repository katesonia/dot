var DotToken = artifacts.require("DotToken");

module.exports = function(deployer) {
  deployer.deploy(DotToken);
};