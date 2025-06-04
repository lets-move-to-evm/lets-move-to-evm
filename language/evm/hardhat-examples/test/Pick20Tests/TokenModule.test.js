const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const TokenModule = artifacts.require('TokenModule');

contract('TokenModule', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let TokenModuleABI = [
        'function protectionLayer(address to, bytes cb)',
        'function initializeBalance(uint64)',
        'function transfer(address,uint64)',
    ];
    let tokensModuleInterface = new ethers.utils.Interface(TokenModuleABI);

    before(async function () {
        this.tokenModule = await TokenModule.new({ from: deployer });
    });

    describe('TokenModule', function () {
        it('should initialize balance', async function () {
            let initializeBalanceEncoding =
                tokensModuleInterface.encodeFunctionData('initializeBalance', [
                    1000,
                ]);
            let result = await this.tokenModule.protectionLayer(
                this.tokenModule.address,
                initializeBalanceEncoding,
                { from: user1 }
            );
            console.log('Initialize balance cost: ', result.receipt.gasUsed);
        });
        it('should initialize balance with zero', async function () {
            let initializeBalanceEncoding =
                tokensModuleInterface.encodeFunctionData('initializeBalance', [
                    0,
                ]);
            let result = await this.tokenModule.protectionLayer(
                this.tokenModule.address,
                initializeBalanceEncoding,
                { from: user2 }
            );
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
            let transferEncoding = tokensModuleInterface.encodeFunctionData(
                'transfer',
                [user2, 1000]
            );
            let result = await this.tokenModule.protectionLayer(
                this.tokenModule.address,
                transferEncoding,
                { from: user1 }
            );
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
