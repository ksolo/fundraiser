const Fundraiser = artifacts.require('./Fundraiser.sol');

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Fundraiser);
}
