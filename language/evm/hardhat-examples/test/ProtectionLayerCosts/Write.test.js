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
        'function write(uint256 value)',
        'function read() returns (uint256)',
        'function edit(uint256,address)',
        'function get() returns (uint256)',
        'function put(uint256)',
        'function remove() returns (uint256)',
        'function sink(uint256)',
    ];

    let protectionLayerInterface = new ethers.utils.Interface(
        protectionLayerABI
    );

    describe('Protection layer gas costs', function () {
        beforeEach(async function () {
            this.protectionLayerCosts = await ProtectionLayerCosts.new();
        });
        it('Calling protection layer on itself on write function', async function () {
            let writeEncoding = protectionLayerInterface.encodeFunctionData(
                'write',
                [14]
            );
            await this.protectionLayerCosts.protectionLayer(
                this.protectionLayerCosts.address,
                writeEncoding
            );
        });
    });
});
