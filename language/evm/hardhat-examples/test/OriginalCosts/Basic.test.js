const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const OriginalCosts = artifacts.require('OriginalCosts');

contract('OriginalCosts', function (accounts) {
    const [deployer, user1, user2] = accounts;

    describe('Original gas costs', function () {
        before(async function () {
            this.originalCosts = await OriginalCosts.new();
        });
        it('Calling doNothing function', async function () {
            await this.originalCosts.doNothing();
        });
        it('Calling write function', async function () {
            await this.originalCosts.write(14);
        });
        it('Calling read function', async function () {
            await this.originalCosts.read();
        });
        it('Calling edit function', async function () {
            await this.originalCosts.edit(44, deployer);
        });
        it('Calling get function', async function () {
            await this.originalCosts.get();
        });
        it('Calling remove function', async function () {
            await this.originalCosts.remove();
        });
        it('Calling put function', async function () {
            await this.originalCosts.put([14]);
        });
        it('Calling sink function', async function () {
            await this.originalCosts.sink([14]);
        });
    });
});
