const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Uq64x64 = artifacts.require('Uq64x64');
const Uq64x64Test = artifacts.require('Uq64x64Test');

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
        it('should call testEncode', async function () {
            let testEncodeEncoding = Uq64x64TestInterface.encodeFunctionData(
                'encodeTest',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testEncodeEncoding,
                { from: user1 }
            );
            console.log('Uq64x64 testEncode cost: ', result.receipt.gasUsed);
        });

        it('should call testDecode', async function () {
            let testDecodeEncoding = Uq64x64TestInterface.encodeFunctionData(
                'decodeTest',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testDecodeEncoding,
                { from: user1 }
            );
            console.log('Uq64x64 testDecode cost: ', result.receipt.gasUsed);
        });

        it('should call testToU128', async function () {
            let testToU128Encoding = Uq64x64TestInterface.encodeFunctionData(
                'toU128Test',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testToU128Encoding,
                { from: user1 }
            );
            console.log('Uq64x64 testToU128 cost: ', result.receipt.gasUsed);
        });

        it('should call testMul', async function () {
            let testMulEncoding = Uq64x64TestInterface.encodeFunctionData(
                'mulTest',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testMulEncoding,
                { from: user1 }
            );
            console.log('Uq64x64 testMul cost: ', result.receipt.gasUsed);
        });

        it('should call testDiv', async function () {
            let testDivEncoding = Uq64x64TestInterface.encodeFunctionData(
                'divTest',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testDivEncoding,
                {
                    from: user1,
                }
            );
            console.log('Uq64x64 testDiv cost: ', result.receipt.gasUsed);
        });
        it('should call testFraction', async function () {
            let testFractionEncoding = Uq64x64TestInterface.encodeFunctionData(
                'fractionTest',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testFractionEncoding,
                { from: user1 }
            );
            console.log('Uq64x64 testFraction cost: ', result.receipt.gasUsed);
        });
        it('should call testCompare', async function () {
            let testCompareEncoding = Uq64x64TestInterface.encodeFunctionData(
                'compareTest',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testCompareEncoding,
                { from: user1 }
            );
            console.log('Uq64x64 testCompare cost: ', result.receipt.gasUsed);
        });
        it('should call testIsZero', async function () {
            let testIsZeroEncoding = Uq64x64TestInterface.encodeFunctionData(
                'isZeroTest',
                [user1]
            );
            let result = await this.uq64x64.protectionLayer(
                this.uq64x64Test.address,
                testIsZeroEncoding,
                { from: user1 }
            );
            console.log('Uq64x64 testIsZero cost: ', result.receipt.gasUsed);
        });
    });
});
