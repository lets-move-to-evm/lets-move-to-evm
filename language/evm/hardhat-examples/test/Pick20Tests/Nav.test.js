const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Nav = artifacts.require('Nav');

contract('Nav', function (accounts) {
    const [deployer, user1, user2] = accounts;
    let NavABI = [
        'function protectionLayer(address to, bytes cb)',
        'function initNav()',
        'function updateAssetValue(uint64 assetValue)',
        'function updateTokenSupply(uint64 tokenSupply)',
        'function calculateNav() returns (uint64)',
    ];

    let aliensEventsInterface = new ethers.utils.Interface(NavABI);

    before(async function () {
        this.aliensEvents = await Nav.new({ from: deployer });
    });
    describe('Nav', function () {
        it('should call initNav', async function () {
            let initNavEncoding = aliensEventsInterface.encodeFunctionData(
                'initNav',
                []
            );
            let result = await this.aliensEvents.protectionLayer(
                this.aliensEvents.address,
                initNavEncoding,
                { from: user1 }
            );
            console.log('Init nav cost: ', result.receipt.gasUsed);
        });
        it('should call updateAssetValue', async function () {
            let updateAssetValueEncoding =
                aliensEventsInterface.encodeFunctionData('updateAssetValue', [
                    1000,
                ]);
            let result = await this.aliensEvents.protectionLayer(
                this.aliensEvents.address,
                updateAssetValueEncoding,
                { from: user1 }
            );
            console.log('Update asset value cost: ', result.receipt.gasUsed);
        });
        it('should call updateTokenSupply', async function () {
            let updateTokenSupplyEncoding =
                aliensEventsInterface.encodeFunctionData('updateTokenSupply', [
                    1000,
                ]);
            let result = await this.aliensEvents.protectionLayer(
                this.aliensEvents.address,
                updateTokenSupplyEncoding,
                { from: user1 }
            );
            console.log('Update token supply cost: ', result.receipt.gasUsed);
        });
        it('should call calculateNav', async function () {
            let calculateNavEncoding = aliensEventsInterface.encodeFunctionData(
                'calculateNav',
                []
            );
            let result = await this.aliensEvents.protectionLayer(
                this.aliensEvents.address,
                calculateNavEncoding,
                { from: user1 }
            );
            console.log('Calculate nav cost: ', result.receipt.gasUsed);
        });
    });
});
