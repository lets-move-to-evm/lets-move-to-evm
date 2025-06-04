const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const MultiAdmin = artifacts.require('MultiAdmin');

contract('MultiAdmin', function (accounts) {
    const [deployer, user1, user2] = accounts;
    let MultiAdminABI = [
        'function protectionLayer(address to, bytes cb)',
        'function initialize()',
        'function setAdmin(address)',
    ];
    let multiAdminInterface = new ethers.utils.Interface(MultiAdminABI);

    before(async function () {
        this.multiAdmin = await MultiAdmin.new({ from: deployer });
    });

    describe('MultiAdmin', function () {
        it('should initialize', async function () {
            let initializeEncoding = multiAdminInterface.encodeFunctionData(
                'initialize',
                []
            );
            let result = await this.multiAdmin.protectionLayer(
                this.multiAdmin.address,
                initializeEncoding,
                { from: user1 }
            );
            console.log('Initialize cost: ', result.receipt.gasUsed);
        });
        it('should set admin', async function () {
            let setAdminEncoding = multiAdminInterface.encodeFunctionData(
                'setAdmin',
                [user2]
            );
            let result = await this.multiAdmin.protectionLayer(
                this.multiAdmin.address,
                setAdminEncoding,
                { from: user1 }
            );
            console.log('Set admin cost: ', result.receipt.gasUsed);
        });
    });
});
