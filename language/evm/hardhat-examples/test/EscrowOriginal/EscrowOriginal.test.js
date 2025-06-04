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
const EscrowOriginal = artifacts.require('EscrowOriginal');

contract('EscrowOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.basicCoinOriginal = await BasicCoinOriginal.new({
            from: deployer,
        });

        // register the deployer
        await this.basicCoinOriginal.register({ from: deployer });

        // Register user1
        await this.basicCoinOriginal.register({ from: user1 });
        // Mint to user 1
        await this.basicCoinOriginal.mintTo(200, user1, { from: deployer });

        // Register user2
        await this.basicCoinOriginal.register({ from: user2 });
        // Mint to user 2
        await this.basicCoinOriginal.mintTo(200, user2, { from: deployer });
    });
    describe('when everyting is set up', function () {
        beforeEach(async function () {
            this.escrowOriginal = await EscrowOriginal.new(
                this.basicCoinOriginal.address,
                user1,
                100,
                {
                    from: deployer,
                }
            );

            let result = await this.escrowOriginal.deposit(100, {
                from: user1,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('user 1 should be able to pay', async function () {
            let result = await this.escrowOriginal.pay({ from: user1 });
            console.log('Pay cost: ', result.receipt.gasUsed);
        });
        it('seller should be able to refund', async function () {
            let result = await this.escrowOriginal.refund({ from: deployer });
            console.log('Refund cost: ', result.receipt.gasUsed);
        });
    });
});
