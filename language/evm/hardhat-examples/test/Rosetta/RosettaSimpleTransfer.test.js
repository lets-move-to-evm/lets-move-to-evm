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

const RosettaSimpleTransfer = artifacts.require('RosettaSimpleTransfer');

contract('RosettaSimpleTransfer', async function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.rosettaSimpleTransfer = await RosettaSimpleTransfer.new(user2, {
            from: user1,
        });
    });

    describe('After deployment', async function () {
        it('User1 could deposit', async function () {
            let result = await this.rosettaSimpleTransfer.deposit({
                from: user1,
                value: 1000,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('User2 could withdraw', async function () {
            let result = await this.rosettaSimpleTransfer.withdraw(100, {
                from: user2,
            });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
    });
});
