const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const ReqLevOriginal = artifacts.require('ReqLevOriginal');

contract('ReqLevOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.reqLev = await ReqLevOriginal.new({ from: deployer });
    });

    describe('ReqLevOriginal', function () {
        it('should call create prep market', async function () {
            // sig=b"createPerpMarket(string,string,string,uint8,uint8,uint64,uint64,uint64,uint64)"
            let result = await this.reqLev.createPerpMarket(
                'ETH',
                'USDC',
                'ETH/USDC',
                1,
                1,
                1000,
                1000,
                1000,
                1000,
                { from: user1 }
            );
            console.log('Create perp market cost: ', result.receipt.gasUsed);
        });
    });
});
