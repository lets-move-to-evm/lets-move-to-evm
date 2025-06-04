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
const CrowdFund = artifacts.require('CrowdfundOriginal');

contract('Crowdfund', function (accounts) {
    const [deployer, user1, user2, reclaimer, receiver] = accounts;

    before(async function () {
        this.basicCoin = await BasicCoinOriginal.new({ from: deployer });

        // register the deployer
        await this.basicCoin.register({ from: deployer });

        // Register user1
        await this.basicCoin.register({ from: user1 });
        // Mint to user 1
        await this.basicCoin.mintTo(200, user1, { from: deployer });

        // Register user2
        await this.basicCoin.register({ from: user2 });
        // Mint to user 2
        await this.basicCoin.mintTo(200, user2, { from: deployer });

        // Register reclaimer
        await this.basicCoin.register({ from: reclaimer });
        // Mint to reclaimer
        await this.basicCoin.mintTo(200, reclaimer, { from: deployer });

        // Register receiver
        await this.basicCoin.register({ from: receiver });
        // Mint to receiver
        await this.basicCoin.mintTo(200, receiver, { from: deployer });
    });
    describe('when everyting is set up', function () {
        before(async function () {
            const timestamp = await time.latest();
            const endDonate = toNumber(timestamp) + 1000;
            this.crowdfund = await CrowdFund.new(
                this.basicCoin.address,
                endDonate,
                200,
                receiver
            );
        });
        it('user 1 should be able to donate', async function () {
            let result = await this.crowdfund.donate(100, { from: user1 });
            console.log('Donate cost: ', result.receipt.gasUsed);
        });
        it('user 2 should be able to donate', async function () {
            let result = await this.crowdfund.donate(200, { from: user2 });
            console.log('Donate cost: ', result.receipt.gasUsed);
        });
        it('reclaimer should be able to donate', async function () {
            let result = await this.crowdfund.donate(200, { from: reclaimer });
            console.log('Donate cost: ', result.receipt.gasUsed);
        });
        it('reclaimer should be able to reclaim', async function () {
            // increase time to end the donation period
            await time.increase(2000);
            let result = await this.crowdfund.reclaim({ from: reclaimer });
            console.log('Reclaim cost: ', result.receipt.gasUsed);
        });
        it('receiver should be able to withdraw', async function () {
            let result = await this.crowdfund.withdraw({ from: receiver });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
    });
});
