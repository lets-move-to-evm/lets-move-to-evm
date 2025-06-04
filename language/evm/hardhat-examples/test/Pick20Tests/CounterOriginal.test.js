const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const CounterOriginal = artifacts.require('CounterOriginal');

contract('CounterOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.counter = await CounterOriginal.new({ from: deployer });
    });

    describe('CounterOriginal', function () {
        it('should create counter', async function () {
            let result = await this.counter.createCounter({ from: user1 });
            console.log('Create counter cost: ', result.receipt.gasUsed);
        });
        it('should push counter', async function () {
            let result = await this.counter.pushCounter(100, {
                from: user1,
            });
            console.log('Push counter cost: ', result.receipt.gasUsed);
        });
        it('should create price', async function () {
            let result = await this.counter.createPrice({
                from: user1,
            });
            console.log('Create price cost: ', result.receipt.gasUsed);
        });
        it('should push price', async function () {
            let result = await this.counter.pushPrice(100, 1, {
                from: user1,
            });
            console.log('Push price cost: ', result.receipt.gasUsed);
        });
    });
});
