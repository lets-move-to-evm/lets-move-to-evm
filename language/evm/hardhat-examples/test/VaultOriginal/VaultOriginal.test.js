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
const VaultOriginal = artifacts.require('VaultOriginal');

contract('VaultOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.basicCoinOriginal = await BasicCoinOriginal.new({
            from: deployer,
        });

        this.vaultOriginal = await VaultOriginal.new({ from: deployer });

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
            let result = await this.vaultOriginal.init(
                user1,
                1000,
                this.basicCoinOriginal.address,
                { from: deployer }
            );
            console.log('Init cost: ', result.receipt.gasUsed);
        });

        it('deployer should be able to deposit', async function () {
            let result = await this.vaultOriginal.deposit(300, {
                from: deployer,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to withdraw', async function () {
            let result = await this.vaultOriginal.withdraw(100, user1, {
                from: deployer,
            });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to finalize', async function () {
            // increase time
            await time.increase(1000);
            let result = await this.vaultOriginal.finalize({
                from: deployer,
            });
            console.log('Finalize cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to withdraw', async function () {
            let result = await this.vaultOriginal.withdraw(100, user1, {
                from: deployer,
            });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to cancel', async function () {
            let result = await this.vaultOriginal.cancel(user1, {
                from: deployer,
            });
            console.log('Cancel cost: ', result.receipt.gasUsed);
        });
    });
});
