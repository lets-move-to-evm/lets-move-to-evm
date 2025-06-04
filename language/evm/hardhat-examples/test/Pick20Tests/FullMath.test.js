const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const FullMath = artifacts.require('FullMath');

contract('FullMath', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.math = await FullMath.new({ from: deployer });
    });

    describe('FullMath', function () {
        it('should calculate mulDivFloor', async function () {
            let result = await this.math.mulDivFloor(100, 200, 300, {
                from: user1,
            });
            console.log('mulDivFloor cost: ', result.receipt.gasUsed);
        });
        it('should calculate mulDivRound', async function () {
            let result = await this.math.mulDivRound(100, 200, 300, {
                from: user1,
            });
            console.log('mulDivRound cost: ', result.receipt.gasUsed);
        });
        it('should calculate mulDivCeil', async function () {
            let result = await this.math.mulDivCeil(100, 200, 300, {
                from: user1,
            });
            console.log('mulDivCeil cost: ', result.receipt.gasUsed);
        });
        it('should calculate mulShr', async function () {
            let result = await this.math.mulShr(100, 200, 8, {
                from: user1,
            });
            console.log('mulShr cost: ', result.receipt.gasUsed);
        });
        it('should calculate mulShl', async function () {
            let result = await this.math.mulShl(100, 200, 8, {
                from: user1,
            });
            console.log('mulShl cost: ', result.receipt.gasUsed);
        });
        it('should calculate fullMul', async function () {
            let result = await this.math.fullMul(100, 200, {
                from: user1,
            });
            console.log('fullMul cost: ', result.receipt.gasUsed);
        });
    });
});
