const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const I64Original = artifacts.require('I64Original');
const I64OriginalTest = artifacts.require('I64OriginalTest');

contract('I64Original', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let I64ABI = ['function protectionLayer(address to, bytes cb)'];

    let I64TestABI = [
        'function zeroTest(address signer)',
        'function fromU64Test(address signer)',
        'function fromTest(address signer)',
        'function fromNegTest(address signer)',
        'function wrappingAddTest(address signer)',
        'function addTest(address signer)',
        'function wrappingSubTest(address signer)',
        'function subTest(address signer)',
        'function mulTest(address signer)',
        'function divTest(address signer)',
        'function absTest(address signer)',
        'function absU64Test(address signer)',
        'function minTest(address signer)',
        'function maxTest(address signer)',
        'function powTest(address signer)',
    ];

    let I64Interface = new ethers.utils.Interface(I64ABI);
    let I64TestInterface = new ethers.utils.Interface(I64TestABI);

    before(async function () {
        this.i64 = await I64Original.new({ from: deployer });
        this.i64Test = await I64OriginalTest.new(this.i64.address, {
            from: deployer,
        });
    });

    describe('I64Original', function () {
        it('should call zeroTest', async function () {
            let result = await this.i64Test.zeroTest(user1, {
                from: user1,
            });
            console.log('I64Original zeroTest cost: ', result.receipt.gasUsed);
        });
        it('should call fromU64Test', async function () {
            let result = await this.i64Test.fromU64Test(user1, {
                from: user1,
            });
            console.log(
                'I64Original fromU64Test cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call fromTest', async function () {
            let result = await this.i64Test.fromTest(user1, {
                from: user1,
            });
            console.log('I64Original fromTest cost: ', result.receipt.gasUsed);
        });
        it('should call fromNegTest', async function () {
            let result = await this.i64Test.fromNegTest(user1, {
                from: user1,
            });
            console.log(
                'I64Original fromNegTest cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call wrappingAddTest', async function () {
            let result = await this.i64Test.wrappingAddTest(user1, {
                from: user1,
            });
            console.log(
                'I64Original wrappingAddTest cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call addTest', async function () {
            let result = await this.i64Test.addTest(user1, {
                from: user1,
            });
            console.log('I64Original addTest cost: ', result.receipt.gasUsed);
        });
        it('should call wrappingSubTest', async function () {
            let result = await this.i64Test.wrappingSubTest(user1, {
                from: user1,
            });
            console.log(
                'I64Original wrappingSubTest cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call subTest', async function () {
            let result = await this.i64Test.subTest(user1, {
                from: user1,
            });
            console.log('I64Original subTest cost: ', result.receipt.gasUsed);
        });
        it('should call mulTest', async function () {
            let result = await this.i64Test.mulTest(user1, {
                from: user1,
            });
            console.log('I64Original mulTest cost: ', result.receipt.gasUsed);
        });
        it('should call divTest', async function () {
            let result = await this.i64Test.divTest(user1, {
                from: user1,
            });
            console.log('I64Original divTest cost: ', result.receipt.gasUsed);
        });
        it('should call absTest', async function () {
            let result = await this.i64Test.absTest(user1, {
                from: user1,
            });
            console.log('I64Original absTest cost: ', result.receipt.gasUsed);
        });
        it('should call absU64Test', async function () {
            let result = await this.i64Test.absU64Test(user1, {
                from: user1,
            });
            console.log(
                'I64Original absU64Test cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call minTest', async function () {
            let result = await this.i64Test.minTest(user1, {
                from: user1,
            });
            console.log('I64Original minTest cost: ', result.receipt.gasUsed);
        });
        it('should call maxTest', async function () {
            let result = await this.i64Test.maxTest(user1, {
                from: user1,
            });
            console.log('I64Original maxTest cost: ', result.receipt.gasUsed);
        });
        it('should call powTest', async function () {
            let result = await this.i64Test.powTest(user1, {
                from: user1,
            });
            console.log('I64Original powTest cost: ', result.receipt.gasUsed);
        });
    });
});
