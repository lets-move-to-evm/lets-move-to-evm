const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const NavOriginal = artifacts.require('NavOriginal');

contract('NavOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.aliensEvents = await NavOriginal.new({ from: deployer });
    });
    describe('NavOriginal', function () {
        it('should call initNav', async function () {
            let result = await this.aliensEvents.initNav({
                from: user1,
            });
            console.log('Init nav cost: ', result.receipt.gasUsed);
        });
        it('should call updateAssetValue', async function () {
            let result = await this.aliensEvents.updateAssetValue(1000, {
                from: user1,
            });
            console.log('Update asset value cost: ', result.receipt.gasUsed);
        });
        it('should call updateTokenSupply', async function () {
            let result = await this.aliensEvents.updateTokenSupply(1000, {
                from: user1,
            });
            console.log('Update token supply cost: ', result.receipt.gasUsed);
        });
        it('should call calculateNav', async function () {
            let result = await this.aliensEvents.calculateNav({
                from: user1,
            });
            console.log('Calculate nav cost: ', result.receipt.gasUsed);
        });
    });
});
