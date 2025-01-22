const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const OriginalCosts = artifacts.require('OriginalCosts');
const OriginalCostsHelper = artifacts.require('OriginalCostsHelper');

contract('OriginalCosts', function (accounts) {
    const [deployer, user1, user2] = accounts;

    describe('Original gas costs', function () {
        before(async function () {
            this.originalCosts = await OriginalCosts.new();
            this.originalCostsHelper = await OriginalCostsHelper.new(
                this.originalCosts.address
            );
        });
        it('Calling write function', async function () {
            await this.originalCostsHelper.write(14);
        });
        it('Calling read function', async function () {
            await this.originalCostsHelper.read();
        });
        it('Calling edit function', async function () {
            await this.originalCostsHelper.edit(44);
        });
        it('Calling get function', async function () {
            await this.originalCostsHelper.get();
        });
        it('Calling remove function', async function () {
            await this.originalCostsHelper.remove();
        });
        it('Calling put function', async function () {
            await this.originalCostsHelper.put();
        });
        it('Calling sink function', async function () {
            await this.originalCostsHelper.sink();
        });
        it('Calling remove function', async function () {
            await this.originalCostsHelper.remove();
        });
        it('Calling writeAndEdit function', async function () {
            await this.originalCostsHelper.writeAndEdit();
        });
        it('Calling remove function', async function () {
            await this.originalCostsHelper.remove();
        });
        it('Calling getAndPut function', async function () {
            await this.originalCostsHelper.getAndPut();
        });
        it('Calling getAndSink function', async function () {
            await this.originalCostsHelper.getAndSink();
        });
        it('Calling getAndStoreExternal function', async function () {
            await this.originalCostsHelper.getAndStoreExternal();
        });
    });
});
