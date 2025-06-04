const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const BasicCoin = artifacts.require('BasicCoinOriginal');

contract('BasicCoin', function (accounts) {
    const [deployer, user1, user2] = accounts;

    beforeEach(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });

        await this.basicCoin.register({ from: user1 });

        await this.basicCoin.register({ from: user2 });

        expect(await this.basicCoin.getBalance(user1)).to.be.bignumber.equal(
            '0'
        );
        expect(await this.basicCoin.getBalance(user2)).to.be.bignumber.equal(
            '0'
        );

        await this.basicCoin.mintTo('10000', user1, { from: deployer });
    });

    describe('when everything is set up', function () {
        it('should allow to transfer', async function () {
            let result = await this.basicCoin.transfer(user2, '1', {
                from: user1,
            });
        });
    });
});
