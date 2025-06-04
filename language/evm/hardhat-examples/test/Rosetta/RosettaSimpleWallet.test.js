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

const RosettaSimpleWallet = artifacts.require('RosettaSimpleWallet');

contract('RosettaSimpleWallet', async function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.rosettaSimpleWallet = await RosettaSimpleWallet.new(user1, {
            from: deployer,
        });
    });
    describe('After deployment', async function () {
        it('User2 could deposit', async function () {
            let result = await this.rosettaSimpleWallet.deposit({
                from: user2,
                value: 1000,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('User1 could withdraw', async function () {
            let result = await this.rosettaSimpleWallet.withdraw({
                from: user1,
            });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('User2 could deposit', async function () {
            let result = await this.rosettaSimpleWallet.deposit({
                from: user2,
                value: 1000,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('User1 could create a transaction', async function () {
            let result = await this.rosettaSimpleWallet.createTransaction(
                user2,
                100,
                '0x000000',
                {
                    from: user1,
                }
            );
            console.log('Create transaction cost: ', result.receipt.gasUsed);
        });
        it('User1 could execute a transaction', async function () {
            let result = await this.rosettaSimpleWallet.executeTransaction(0, {
                from: user1,
            });
            console.log('Approve transaction cost: ', result.receipt.gasUsed);
        });
    });
});
