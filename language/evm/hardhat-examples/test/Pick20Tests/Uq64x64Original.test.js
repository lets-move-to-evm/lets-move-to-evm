const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Uq64x64Original = artifacts.require('Uq64x64Original');

contract('Uq64x64Original', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.uq64x64 = await Uq64x64Original.new({ from: deployer });
    });

    describe('Uq64x64Original', function () {
        it('should call encode', async function () {
            let result = await this.uq64x64.encode(47, { from: user1 });
            console.log('Encode cost: ', result.receipt.gasUsed);
        });

        it('should call decode', async function () {
            let result = await this.uq64x64.decode([47], { from: user1 });
            console.log('Decode cost: ', result.receipt.gasUsed);
        });

        it('should call toU128', async function () {
            let result = await this.uq64x64.toU128([47], { from: user1 });
            console.log('toU128 cost: ', result.receipt.gasUsed);
        });
        it('should call mul', async function () {
            let result = await this.uq64x64.mul([47], 3, { from: user1 });
            console.log('mul cost: ', result.receipt.gasUsed);
        });
        it('should call div', async function () {
            let result = await this.uq64x64.div([47], 3, { from: user1 });
            console.log('div cost: ', result.receipt.gasUsed);
        });
        it('should call fraction', async function () {
            let result = await this.uq64x64.fraction(47, 3, { from: user1 });
            console.log('fraction cost: ', result.receipt.gasUsed);
        });
        it('should call compare', async function () {
            let result = await this.uq64x64.compare([47], [47], {
                from: user1,
            });
            console.log('compare cost: ', result.receipt.gasUsed);
        });
        it('should call isZero', async function () {
            let result = await this.uq64x64.isZero([1], { from: user1 });
            console.log('isZero cost: ', result.receipt.gasUsed);
        });
    });
});
