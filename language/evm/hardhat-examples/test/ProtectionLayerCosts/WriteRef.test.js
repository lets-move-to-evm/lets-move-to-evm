const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const ProtectionLayerCosts = artifacts.require('ProtectionLayerCosts');
const ProtectionLayerCostsHelper = artifacts.require(
    'ProtectionLayerCostsHelper'
);

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

    let protectionLayerHelperABI = ['function writeRef(address signer)'];

    let protectionLayerInterface = new ethers.utils.Interface(
        protectionLayerABI
    );

    let protectionLayerHelperInterface = new ethers.utils.Interface(
        protectionLayerHelperABI
    );

    describe('Protection layer gas costs', function () {
        beforeEach(async function () {
            this.protectionLayerCosts = await ProtectionLayerCosts.new();
            this.protectionLayerCostsHelper =
                await ProtectionLayerCostsHelper.new(
                    this.protectionLayerCosts.address
                );
            // let writeEncoding = protectionLayerInterface.encodeFunctionData(
            //     'write',
            //     [14]
            // );
            // this.protectionLayerCosts = await ProtectionLayerCosts.new();
            // await this.protectionLayerCosts.protectionLayer(
            //     this.protectionLayerCosts.address,
            //     writeEncoding
            // );
        });
        it('Calling protection layer on external contract on writeRef function', async function () {
            let writeRefEncoding =
                protectionLayerHelperInterface.encodeFunctionData('writeRef', [
                    deployer,
                ]);
            await this.protectionLayerCosts.protectionLayer(
                this.protectionLayerCostsHelper.address,
                writeRefEncoding
            );
        });
    });
});
