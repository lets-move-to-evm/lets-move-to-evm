const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const ReqLev = artifacts.require('ReqLev');

contract('ReqLev', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let ReqLevABI = [
        'function protectionLayer(address to, bytes cb)',
        'function createPerpMarket(string,string,string,uint8,uint8,uint64,uint64,uint64,uint64)',
    ];
    let aliensEventsInterface = new ethers.utils.Interface(ReqLevABI);

    before(async function () {
        this.reqLev = await ReqLev.new({ from: deployer });
    });

    describe('ReqLev', function () {
        it('should call create prep market', async function () {
            // sig=b"createPerpMarket(string,string,string,uint8,uint8,uint64,uint64,uint64,uint64)"
            let createPerpMarketEncoding =
                aliensEventsInterface.encodeFunctionData('createPerpMarket', [
                    'ETH',
                    'USDC',
                    'ETH/USDC',
                    1,
                    1,
                    1000,
                    1000,
                    1000,
                    1000,
                ]);
            let result = await this.reqLev.protectionLayer(
                this.reqLev.address,
                createPerpMarketEncoding,
                { from: user1 }
            );
            console.log('Create perp market cost: ', result.receipt.gasUsed);
        });
    });
});
