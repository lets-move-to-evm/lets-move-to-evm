const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Bytes32Original = artifacts.require('Bytes32Original');
const Bytes32Test = artifacts.require('Bytes32OriginalTest');

contract('Bytes32 Original', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.bytes32 = await Bytes32Original.new({ from: deployer });
        this.bytes32Test = await Bytes32Test.new(this.bytes32.address, {
            from: deployer,
        });
    });

    describe('Bytes32 Original', function () {
        it('should call zeroBytes32Test', async function () {
            let result = await this.bytes32Test.zeroBytes32Test(user1, {
                from: user1,
            });
            console.log(
                'Bytes32 Original zeroBytes32Test cost: ',
                result.receipt.gasUsed
            );
        });

        it('should call ffBytes32Test', async function () {
            let result = await this.bytes32Test.ffBytes32Test(user1, {
                from: user1,
            });
            console.log(
                'Bytes32 Original ffBytes32Test cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call isZeroTest', async function () {
            let result = await this.bytes32Test.isZeroTest(user1, {
                from: user1,
            });
            console.log(
                'Bytes32 Original isZeroTest cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call tobytes32Test', async function () {
            let result = await this.bytes32Test.toBytes32Test(user1, {
                from: user1,
            });
            console.log(
                'Bytes32 Original tobytes32Test cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call frombytes32Test', async function () {
            let result = await this.bytes32Test.fromBytes32Test(user1, {
                from: user1,
            });
            console.log(
                'Bytes32 Original frombytes32Test cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should call fromAddressTest', async function () {
            let result = await this.bytes32Test.fromAddressTest(user1, {
                from: user1,
            });
            console.log(
                'Bytes32 Original fromAddressTest cost: ',
                result.receipt.gasUsed
            );
        });
    });
});
