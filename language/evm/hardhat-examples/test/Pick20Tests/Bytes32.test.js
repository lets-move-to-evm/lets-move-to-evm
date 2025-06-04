const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Bytes32 = artifacts.require('Bytes32');
const Bytes32Test = artifacts.require('Bytes32Test');

contract('Bytes32', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let Bytes32ABI = ['function protectionLayer(address to, bytes cb)'];

    let Bytes32TestABI = [
        'function zeroBytes32Test(address signer)',
        'function ffBytes32Test(address signer)',
        'function isZeroTest(address signer)',
        'function toBytes32Test(address signer)',
        'function fromBytes32Test(address signer)',
        'function fromAddressTest(address signer)',
    ];

    let bytes32Interface = new ethers.utils.Interface(Bytes32ABI);
    let Bytes32TestInterface = new ethers.utils.Interface(Bytes32TestABI);

    before(async function () {
        this.bytes32 = await Bytes32.new({ from: deployer });
        this.bytes32Test = await Bytes32Test.new(this.bytes32.address, {
            from: deployer,
        });
    });

    describe('Bytes32', function () {
        it('should call zeroBytes32Test', async function () {
            let zeroBytes32Encoding = Bytes32TestInterface.encodeFunctionData(
                'zeroBytes32Test',
                [user1]
            );
            let result = await this.bytes32.protectionLayer(
                this.bytes32Test.address,
                zeroBytes32Encoding,
                { from: user1 }
            );
            console.log(
                'Bytes32 zeroBytes32Test cost: ',
                result.receipt.gasUsed
            );
        });

        it('should call ffBytes32Test', async function () {
            let ffBytes32Encoding = Bytes32TestInterface.encodeFunctionData(
                'ffBytes32Test',
                [user1]
            );
            let result = await this.bytes32.protectionLayer(
                this.bytes32Test.address,
                ffBytes32Encoding,
                { from: user1 }
            );
            console.log('Bytes32 ffBytes32Test cost: ', result.receipt.gasUsed);
        });
        it('should call isZeroTest', async function () {
            let isZeroEncoding = Bytes32TestInterface.encodeFunctionData(
                'isZeroTest',
                [user1]
            );
            let result = await this.bytes32.protectionLayer(
                this.bytes32Test.address,
                isZeroEncoding,
                { from: user1 }
            );
            console.log('Bytes32 isZeroTest cost: ', result.receipt.gasUsed);
        });
        it('should call tobytes32Test', async function () {
            let tobytes32Encoding = Bytes32TestInterface.encodeFunctionData(
                'toBytes32Test',
                [user1]
            );
            let result = await this.bytes32.protectionLayer(
                this.bytes32Test.address,
                tobytes32Encoding,
                { from: user1 }
            );
            console.log('Bytes32 tobytes32Test cost: ', result.receipt.gasUsed);
        });
        it('should call frombytes32Test', async function () {
            let frombytes32Encoding = Bytes32TestInterface.encodeFunctionData(
                'fromBytes32Test',
                [user1]
            );
            let result = await this.bytes32.protectionLayer(
                this.bytes32Test.address,
                frombytes32Encoding,
                { from: user1 }
            );
            console.log(
                'Bytes32 frombytes32Test cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should call fromAddressTest', async function () {
            let fromAddressEncoding = Bytes32TestInterface.encodeFunctionData(
                'fromAddressTest',
                [user1]
            );
            let result = await this.bytes32.protectionLayer(
                this.bytes32Test.address,
                fromAddressEncoding,
                { from: user1 }
            );
            console.log(
                'Bytes32 fromAddressTest cost: ',
                result.receipt.gasUsed
            );
        });
    });
});
