const {
    BN,
    constants,
    expectEvent,
    expectRevert,
    time,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { toNumber } = require('web3-utils');

const { ZERO_ADDRESS } = constants;

const BasicCoinOriginal = artifacts.require('BasicCoinOriginal');
const SimpleWalletOriginal = artifacts.require('SimpleWalletOriginal');

contract('SimpleWalletOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.basicCoinOriginal = await BasicCoinOriginal.new({
            from: deployer,
        });
        this.simpleWallet = await SimpleWalletOriginal.new({ from: deployer });

        // register the deployer
        await this.basicCoinOriginal.register({ from: deployer });
        // Mint to deployer
        await this.basicCoinOriginal.mintTo(2000, deployer, { from: deployer });

        // Register user1
        await this.basicCoinOriginal.register({ from: user1 });
        // Mint to user 1
        await this.basicCoinOriginal.mintTo(2000, user1, { from: deployer });

        // Register user2
        await this.basicCoinOriginal.register({ from: user2 });
        // Mint to user 2
        await this.basicCoinOriginal.mintTo(2000, user2, { from: deployer });
    });
    describe('when everyting is set up', function () {
        before(async function () {
            let result = await this.simpleWallet.initialize(
                this.basicCoinOriginal.address,
                { from: deployer }
            );
            console.log('Initialize cost: ', result.receipt.gasUsed);
        });

        it('user 1 should be able to deposit', async function () {
            let result = await this.simpleWallet.deposit(deployer, 100, {
                from: user1,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to withdraw', async function () {
            let result = await this.simpleWallet.withdraw({
                from: deployer,
            });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('user 2 should be able to deposit', async function () {
            let result = await this.simpleWallet.deposit(deployer, 100, {
                from: user2,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to create a transaction', async function () {
            let result = await this.simpleWallet.createTransaction(
                user1,
                100,
                'ciao',
                { from: deployer }
            );
            console.log('Create transaction cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to execute a transaction', async function () {
            let result = await this.simpleWallet.executeTransaction(0, {
                from: deployer,
            });
            console.log('Execute transaction cost: ', result.receipt.gasUsed);
        });
    });
});
