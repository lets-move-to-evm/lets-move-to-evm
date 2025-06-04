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

const RosettaVesting = artifacts.require('RosettaVesting');

contract('RosettaVesting', async function (accounts) {
    const [deployer, user1, user2] = accounts;
    describe('Vesting execution', async function () {
        before(async function () {
            let now = await time.latest();
            let duration = 10000;
            this.rosettaVesting = await RosettaVesting.new(
                user1,
                now,
                duration,
                { from: deployer }
            );
        });
        describe('After deployment', async function () {
            it('Anyone could release', async function () {
                let result = await this.rosettaVesting.release({
                    from: user1,
                });
                console.log('Release cost: ', result.receipt.gasUsed);
            });
        });
    });
});
