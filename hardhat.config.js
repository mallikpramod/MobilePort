require("@nomicfoundation/hardhat-toolbox");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");
require("dotenv").config();
const {PRIVATE_KEY} = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai:{
      url:"https://polygon-mumbai.g.alchemy.com/v2/wjirmQHAm7a6ClIERn5XF_WTzYaS4rq6",
      accounts:[PRIVATE_KEY] 
    }
  }
};
