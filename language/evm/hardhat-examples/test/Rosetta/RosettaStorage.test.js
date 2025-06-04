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

const RosettaStorage = artifacts.require('RosettaStorage');

contract('RosettaStorage', async function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.rosettaStorage = await RosettaStorage.new({ from: deployer });
    });
    describe('After deployment', async function () {
        it('User1 could store bytes', async function () {
            let result = await this.rosettaStorage.storeBytes(
                ethers.utils.formatBytes32String('ciao'),
                { from: user1 }
            );
            console.log('Store bytes cost: ', result.receipt.gasUsed);
        });
        it('User1 could store string', async function () {
            let result = await this.rosettaStorage.storeString('ciao', {
                from: user1,
            });
            console.log('Store string cost: ', result.receipt.gasUsed);
        });
    });
});
