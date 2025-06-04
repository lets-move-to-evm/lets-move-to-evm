const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Picture = artifacts.require('Picture');

contract('Picture', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.picture = await Picture.new({
            from: deployer,
        });
    });

    describe('Picture', function () {
        it('should vectorize', async function () {
            let result = await this.picture.vectorize('44', { from: user1 });
            console.log('Vectorize cost: ', result.receipt.gasUsed);
        });
        it('should theoreticalD1Values', async function () {
            let result = await this.picture.theoreticalD1Values(5, 2, 3, {
                from: user1,
            });
            console.log('Theoretical D1 values cost: ', result.receipt.gasUsed);
        });
        it('should distance', async function () {
            let result = await this.picture.distance(3, 4, {
                from: user1,
            });
            console.log('Distance cost: ', result.receipt.gasUsed);
        });
        it('should circlesIntersect', async function () {
            let result = await this.picture.circlesIntersect(
                3,
                7,
                19,
                1,
                4,
                6,
                { from: user1 }
            );
            console.log('Circle intersections cost: ', result.receipt.gasUsed);
        });
    });
});
