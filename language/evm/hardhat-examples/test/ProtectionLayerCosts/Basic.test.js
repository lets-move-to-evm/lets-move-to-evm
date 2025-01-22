const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const ProtectionLayerCosts = artifacts.require('ProtectionLayerCosts');

contract('ProtectionLayerCosts', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let protectionLayerABI = [
        'function protectionLayer(address to, bytes cb)',
        'function doNothing()',
        'function fallback()',
    ];

    let protectionLayerInterface = new ethers.utils.Interface(
        protectionLayerABI
    );

    describe('Protection layer gas costs', function () {
        beforeEach(async function () {
            this.protectionLayerCosts = await ProtectionLayerCosts.new();
        });
        it('Calling doNothing function', async function () {
            await this.protectionLayerCosts.doNothing();
        });
        it('Calling protection layer on itself on doNothing function', async function () {
            let doNothingEncoding = protectionLayerInterface.encodeFunctionData(
                'doNothing',
                []
            );
            await this.protectionLayerCosts.protectionLayer(
                this.protectionLayerCosts.address,
                doNothingEncoding
            );
        });
    });
});
