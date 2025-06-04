const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Math2 = artifacts.require('Math2');

contract('Math2', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.math = await Math2.new({ from: deployer });
    });

    describe('Math2', function () {
        it('should call sqrt', async function () {
            let result = await this.math.sqrt(4607431768211455, {
                from: user1,
            });
            console.log('Math2 sqrt cost: ', result.receipt.gasUsed);
        });
        it('should call min', async function () {
            let result = await this.math.min(
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math2 min cost: ', result.receipt.gasUsed);
        });
        it('should call maxU64', async function () {
            let result = await this.math.maxU64(
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math2 maxU64 cost: ', result.receipt.gasUsed);
        });
        it('should call max', async function () {
            let result = await this.math.max(
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math2 max cost: ', result.receipt.gasUsed);
        });
        it('should call pow', async function () {
            let result = await this.math.pow(80, 3, {
                from: user1,
            });
            console.log('Math2 pow cost: ', result.receipt.gasUsed);
        });
    });
});
