const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const ImperfectLockerOriginal = artifacts.require('ImperfectLockerOriginal');

contract('ImperfectLockerOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.locker = await ImperfectLockerOriginal.new({ from: deployer });
    });

    describe('ImperfectLockerOriginal', function () {
        it('should initialize pool', async function () {
            let result = await this.locker.initializePool(100, 100, 100, 100, {
                from: user1,
            });
            console.log('Initialize pool cost: ', result.receipt.gasUsed);
        });
        it('should update pool', async function () {
            let result = await this.locker.updatePool(100, 100, 100, 100, {
                from: user1,
            });
            console.log('Update pool cost: ', result.receipt.gasUsed);
        });
        it('should calculate impermanent loss', async function () {
            let result = await this.locker.calculateImpermanentLoss(user1, {
                from: user1,
            });
            console.log(
                'Calculate impermanent loss cost: ',
                result.receipt.gasUsed
            );
        });
    });
});
