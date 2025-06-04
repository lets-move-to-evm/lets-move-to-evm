const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const TokenModuleOriginal = artifacts.require('TokenModuleOriginal');

contract('TokenModuleOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.tokenModule = await TokenModuleOriginal.new({ from: deployer });
    });

    describe('TokenModuleOriginal', function () {
        it('should initialize balance', async function () {
            let result = await this.tokenModule.initializeBalance(1000, {
                from: user1,
            });
            console.log('Initialize balance cost: ', result.receipt.gasUsed);
        });
        it('should initialize balance with zero', async function () {
            let result = await this.tokenModule.initializeBalance(0, {
                from: user2,
            });
            console.log(
                'Initialize balance with zero cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should initialize balance without parameters', async function () {
            let initializeBalanceEncoding =
                tokensModuleInterface.encodeFunctionData(
                    'initializeBalance',
                    []
                );
            let result = await this.tokenModule.protectionLayer(
                this.tokenModule.address,
                initializeBalanceEncoding,
                { from: user1 }
            );
            console.log(
                'Initialize balance without parameters cost: ',
                result.receipt.gasUsed
            );
        });
        it('should transfer tokens', async function () {
            let result = await this.tokenModule.transfer(user2, 100, {
                from: user1,
            });
            console.log('Transfer tokens cost: ', result.receipt.gasUsed);
        });
        it('should get balance', async function () {
            let result = await this.tokenModule.getBalance(user1, {
                from: user1,
            });
            console.log('Get balance cost: ', result.receipt.gasUsed);
        });
    });
});
