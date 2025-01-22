const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const ReentrantContract = artifacts.require('ReentrantContract');
const AttackerV1 = artifacts.require('AttackerV1');

contract('ReentrantContract', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.reentrantContract = await ReentrantContract.new({ from: deployer });
        this.attackerV1 = await AttackerV1.new({ from: deployer });

        const val = await this.reentrantContract.get();
    });

    describe('when everything is set up', function () {
        it('should allow to start attack', async function () {
            const val = await this.reentrantContract.get();
            const tx = await this.reentrantContract.start_attack(this.attackerV1.address);

            const val2 = await this.reentrantContract.get();
            expect(val2).to.be.bignumber.equal('44');
        });
    });
});