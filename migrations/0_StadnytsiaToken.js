var StadnytsiaToken = artifacts.require('StadnytsiaToken');

module.exports = function(deployer) {
    deployer.deploy(StadnytsiaToken);
  };