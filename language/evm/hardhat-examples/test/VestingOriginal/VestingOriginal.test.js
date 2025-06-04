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
const VestingOriginal = artifacts.require('VestingOriginal');

contract('VestingOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.basicCoinOriginal = await BasicCoinOriginal.new({
            from: deployer,
        });

        this.vestingOriginal = await VestingOriginal.new({ from: deployer });

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
            let result = await this.vestingOriginal.init(
                user1,
                this.basicCoinOriginal.address,
                0,
                1000,
                1000,
                { from: deployer }
            );
            console.log('Init cost: ', result.receipt.gasUsed);
        });
        it('should be able to release', async function () {
            let result = await this.vestingOriginal.release({
                from: deployer,
            });
            console.log('Release cost: ', result.receipt.gasUsed);
        });
    });
});
