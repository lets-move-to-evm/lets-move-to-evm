const {
    BN,
    constants,
    expectEvent,
    expectRevert,
    time,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;
const { toNumber } = require('web3-utils');

const RosettaPriceBet = artifacts.require('RosettaPriceBet');
const ExchangeRate = artifacts.require('Exchange');

contract('RosettaPriceBet', async function (accounts) {
    const [deployer, user1, user2] = accounts;

    describe('Win execution', async function () {
        before(async function () {
            let now = await time.latestBlock();
            let blocks = 100;
            let exchangeRate = 2;
            let payableValue = 1000;
            this.exchangeRate = await ExchangeRate.new();
            this.rosettaPriceBet = await RosettaPriceBet.new(
                this.exchangeRate.address,
                toNumber(now) + blocks,
                exchangeRate,
                { from: deployer, value: payableValue }
            );
        });
        describe('After deployment', async function () {
            it('User1 could join', async function () {
                let result = await this.rosettaPriceBet.join({
                    from: user1,
                    value: 1000,
                });
                console.log('Join cost: ', result.receipt.gasUsed);
            });
            it('User1 could win', async function () {
                let result = await this.rosettaPriceBet.win({
                    from: user1,
                });
                console.log('Win cost: ', result.receipt.gasUsed);
            });
        });
    });

    describe('Timeout execution', async function () {
        before(async function () {
            let now = await time.latestBlock();
            let blocks = 100;
            let exchangeRate = 2;
            let payableValue = 1000;
            this.exchangeRate = await ExchangeRate.new();
            this.rosettaPriceBet = await RosettaPriceBet.new(
                this.exchangeRate.address,
                toNumber(now) + blocks,
                exchangeRate,
                { from: deployer, value: payableValue }
            );
        });
        describe('After deployment', async function () {
            it('User1 could join', async function () {
                let result = await this.rosettaPriceBet.join({
                    from: user1,
                    value: 1000,
                });
                console.log('Join cost: ', result.receipt.gasUsed);
            });
            it('Anyone could timeout', async function () {
                // forward VM time
                let now = await time.latestBlock();
                await time.advanceBlockTo(toNumber(now) + 200);
                let result = await this.rosettaPriceBet.timeout({
                    from: user1,
                });
                console.log('Timeout cost: ', result.receipt.gasUsed);
            });
        });
    });
});
