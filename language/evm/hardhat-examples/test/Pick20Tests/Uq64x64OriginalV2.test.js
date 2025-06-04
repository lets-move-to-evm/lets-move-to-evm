const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Uq64x64 = artifacts.require('Uq64x64Original');
const Uq64x64Test = artifacts.require('Uq64x64TestOriginal');

contract('Uq64x64', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let Uq64x64ABI = ['function protectionLayer(address to, bytes cb)'];

    let Uq64x64TestABI = [
        'function encodeTest(address signer)',
        'function decodeTest(address signer)',
        'function toU128Test(address signer)',
        'function mulTest(address signer)',
        'function divTest(address signer)',
        'function fractionTest(address signer)',
        'function compareTest(address signer)',
        'function isZeroTest(address signer)',
    ];

    let uq64x64Interface = new ethers.utils.Interface(Uq64x64ABI);
    let Uq64x64TestInterface = new ethers.utils.Interface(Uq64x64TestABI);

    before(async function () {
        this.uq64x64 = await Uq64x64.new({ from: deployer });
        this.uq64x64Test = await Uq64x64Test.new(this.uq64x64.address, {
            from: deployer,
        });
    });

    describe('Uq64x64', function () {
        it('should call encodeTest', async function () {
            let result = await this.uq64x64Test.encodeTest(user1);
            console.log('Encode cost: ', result.receipt.gasUsed);
        });
        it('should call decodeTest', async function () {
            let result = await this.uq64x64Test.decodeTest(user1);
            console.log('Decode cost: ', result.receipt.gasUsed);
        });
        it('should call toU128Test', async function () {
            let result = await this.uq64x64Test.toU128Test(user1);
            console.log('toU128 cost: ', result.receipt.gasUsed);
        });
        it('should call mulTest', async function () {
            let result = await this.uq64x64Test.mulTest(user1);
            console.log('mul cost: ', result.receipt.gasUsed);
        });
        it('should call divTest', async function () {
            let result = await this.uq64x64Test.divTest(user1);
            console.log('div cost: ', result.receipt.gasUsed);
        });
        it('should call fractionTest', async function () {
            let result = await this.uq64x64Test.fractionTest(user1);
            console.log('fraction cost: ', result.receipt.gasUsed);
        });
        it('should call compareTest', async function () {
            let result = await this.uq64x64Test.compareTest(user1);
            console.log('compare cost: ', result.receipt.gasUsed);
        });
        it('should call isZeroTest', async function () {
            let result = await this.uq64x64Test.isZeroTest(user1);
            console.log('isZero cost: ', result.receipt.gasUsed);
        });
    });
});
