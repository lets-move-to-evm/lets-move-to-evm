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

const Storage = artifacts.require('Storage');

contract('Storage', function (accounts) {
    const [deployer] = accounts;

    before(async function () {
        this.storage = await Storage.new({ from: deployer });
    });
    it('should store bytes', async function () {
        const data = '0x1234567890abcdef';
        let result = await this.storage.storeBytes(data, { from: deployer });

        console.log('StoreBytes cost:', result.receipt.gasUsed);
    });
    it('should store string', async function () {
        const data = 'Hello, world!';
        let result = await this.storage.storeString(data, { from: deployer });

        console.log('StoreString cost:', result.receipt.gasUsed);
    });
});
