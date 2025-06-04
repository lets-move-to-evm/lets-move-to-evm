const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Counter = artifacts.require('Counter');

contract('Counter', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let CounterABI = [
        'function protectionLayer(address to, bytes cb)',
        'function createCounter()',
        'function pushCounter(uint64)',
        'function createPrice()',
        'function pushPrice(uint64,uint8) returns (uint64)',
    ];
    let counterInterface = new ethers.utils.Interface(CounterABI);

    before(async function () {
        this.counter = await Counter.new({ from: deployer });
    });

    describe('Counter', function () {
        it('should create counter', async function () {
            let createCounterEncoding = counterInterface.encodeFunctionData(
                'createCounter',
                []
            );
            let result = await this.counter.protectionLayer(
                this.counter.address,
                createCounterEncoding,
                { from: user1 }
            );
            console.log('Create counter cost: ', result.receipt.gasUsed);
        });
        it('should push counter', async function () {
            let pushCounterEncoding = counterInterface.encodeFunctionData(
                'pushCounter',
                [100]
            );
            let result = await this.counter.protectionLayer(
                this.counter.address,
                pushCounterEncoding,
                { from: user1 }
            );
            console.log('Push counter cost: ', result.receipt.gasUsed);
        });
        it('should create price', async function () {
            let createPriceEncoding = counterInterface.encodeFunctionData(
                'createPrice',
                []
            );
            let result = await this.counter.protectionLayer(
                this.counter.address,
                createPriceEncoding,
                { from: user1 }
            );
            console.log('Create price cost: ', result.receipt.gasUsed);
        });
        it('should push price', async function () {
            let pushPriceEncoding = counterInterface.encodeFunctionData(
                'pushPrice',
                [100, 1]
            );
            let result = await this.counter.protectionLayer(
                this.counter.address,
                pushPriceEncoding,
                { from: user1 }
            );
            console.log('Push price cost: ', result.receipt.gasUsed);
        });
    });
});
