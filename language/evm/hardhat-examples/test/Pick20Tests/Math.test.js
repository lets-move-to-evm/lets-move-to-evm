const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Math = artifacts.require('Math');

contract('Math', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.math = await Math.new({ from: deployer });
    });

    describe('Math', function () {
        it('should call overflowAdd', async function () {
            let result = await this.math.overflowAdd(
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math overflowAdd cost: ', result.receipt.gasUsed);
        });
        it('should call mulDiv', async function () {
            let result = await this.math.mulDiv(
                4607431768211455,
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math mulDiv cost: ', result.receipt.gasUsed);
        });
        it('should call mulDivU128', async function () {
            let result = await this.math.mulDivU128(
                4607431768211455,
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math mulDivU128 cost: ', result.receipt.gasUsed);
        });
        it('should call mulToU128', async function () {
            let result = await this.math.mulToU128(
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math mulToU128 cost: ', result.receipt.gasUsed);
        });
        it('should call sqrt', async function () {
            let result = await this.math.sqrt(4607431768211455, {
                from: user1,
            });
            console.log('Math sqrt cost: ', result.receipt.gasUsed);
        });
        it('should call pow10', async function () {
            let result = await this.math.pow10(8, {
                from: user1,
            });
            console.log('Math pow10 cost: ', result.receipt.gasUsed);
        });
        it('should call minU64', async function () {
            let result = await this.math.minU64(
                4607431768211455,
                4607431768211455,
                {
                    from: user1,
                }
            );
            console.log('Math minU64 cost: ', result.receipt.gasUsed);
        });
    });
});
