const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const ImperfectLocker = artifacts.require('ImperfectLocker');

contract('ImperfectLocker', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let LockerABI = [
        'function protectionLayer(address to, bytes cb)',
        'function initializePool(uint64,uint64,uint64,uint64)',
        'function updatePool(uint64,uint64,uint64,uint64)',
        'function calculateImpermanentLoss(address) returns (uint64)',
    ];
    let lockerInterface = new ethers.utils.Interface(LockerABI);

    before(async function () {
        this.locker = await ImperfectLocker.new({ from: deployer });
    });

    describe('ImperfectLocker', function () {
        it('should initialize pool', async function () {
            let initializePoolEncoding = lockerInterface.encodeFunctionData(
                'initializePool',
                [100, 100, 100, 100]
            );
            let result = await this.locker.protectionLayer(
                this.locker.address,
                initializePoolEncoding,
                { from: user1 }
            );
            console.log('Initialize pool cost: ', result.receipt.gasUsed);
        });
        it('should update pool', async function () {
            let updatePoolEncoding = lockerInterface.encodeFunctionData(
                'updatePool',
                [100, 100, 100, 100]
            );
            let result = await this.locker.protectionLayer(
                this.locker.address,
                updatePoolEncoding,
                { from: user1 }
            );
            console.log('Update pool cost: ', result.receipt.gasUsed);
        });
        it('should calculate impermanent loss', async function () {
            let calculateImpermanentLossEncoding =
                lockerInterface.encodeFunctionData('calculateImpermanentLoss', [
                    user1,
                ]);
            let result = await this.locker.protectionLayer(
                this.locker.address,
                calculateImpermanentLossEncoding,
                { from: user1 }
            );
            console.log(
                'Calculate impermanent loss cost: ',
                result.receipt.gasUsed
            );
        });
    });
});
