require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-truffle5');
require('hardhat-gas-reporter');
require('hardhat-move');
require('hardhat-tracer');

require('dotenv').config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
});

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY_FOR_ROPSTEN = 'KEY1';
const ALCHEMY_API_KEY_FOR_RINKEBY = 'KEY2';
const ALCHEMY_API_KEY_FOR_SEPOLIA = 'KEY3';
// Replace this private key with your Ropsten account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const PRIVATE_KEY = 'process.env.PRIVATE_KEY';

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
    solidity: {
        version: '0.8.26',
        settings: {
            evmVersion: 'cancun',
        },
    },
    gasReporter: {
        enabled: true,
        // includeIntrinsicGas: false,
    },
    tracer: {
        gasCost: true,
        // opcodes: ['MLOAD', 'MSTORE'],
    },
    networks: {
        // ropsten: {
        //     url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY_FOR_ROPSTEN}`,
        //     accounts: [`${PRIVATE_KEY}`],
        // },
        // rinkeby: {
        //     url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY_FOR_RINKEBY}`,
        //     accounts: [`${PRIVATE_KEY}`],
        // },
        // sepolia: {
        //     url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY_FOR_SEPOLIA}`,
        //     accounts: [`${PRIVATE_KEY}`],
        // },
    },
};
