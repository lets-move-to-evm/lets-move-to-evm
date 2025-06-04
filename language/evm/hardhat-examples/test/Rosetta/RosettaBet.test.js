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

const RosettaBet = artifacts.require('RosettaBet');

contract('RosettaBet', function (accounts) {
    const [deployer, user1, user2, oracle] = accounts;

    let payableValue = 1000;
    let blocks = 10;

    describe('Win execution', async function () {
        before(async function () {
            this.rosettaBet = await RosettaBet.new(oracle, user2, blocks, {
                from: user1,
                value: payableValue,
            });
        });
        describe('After deployment', async function () {
            it('User2 could join the bet', async function () {
                let result = await this.rosettaBet.join({
                    from: user2,
                    value: payableValue,
                });
                console.log('Join cost: ', result.receipt.gasUsed);
            });
            it('Oracle could decide the winner', async function () {
                let result = await this.rosettaBet.win(1, {
                    from: oracle,
                });
                console.log('Win cost: ', result.receipt.gasUsed);
            });
        });
    });
    describe('Timeout execution', async function () {
        before(async function () {
            this.rosettaBet = await RosettaBet.new(oracle, user2, blocks, {
                from: user1,
                value: payableValue,
            });
        });

        describe('After deployment', async function () {
            it('User2 could join the bet', async function () {
                let result = await this.rosettaBet.join({
                    from: user2,
                    value: payableValue,
                });
                console.log('Join cost: ', result.receipt.gasUsed);
            });
            it('Anyone could timeout', async function () {
                await time.advanceBlockTo(
                    toNumber(await time.latestBlock()) + 2 * blocks
                );
                console.log(
                    'Block number:',
                    toNumber(await time.latestBlock())
                );

                let result = await this.rosettaBet.timeout({
                    from: user1,
                });
                console.log('Timeout cost: ', result.receipt.gasUsed);
            });
        });
    });
});
