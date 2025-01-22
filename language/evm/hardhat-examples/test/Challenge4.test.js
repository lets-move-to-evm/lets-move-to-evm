const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const BasicCoin = artifacts.require('BasicCoinOriginal');
const Challenge4 = artifacts.require('Challenge4');

contract('BasicCoin', function (accounts) {
    const [deployer, user1, user2] = accounts;

    beforeEach(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.challenge4 = await Challenge4.new(this.basicCoin.address, {
            from: deployer,
        });

        await this.challenge4.register();
    });

    xdescribe('when everything is set up', function () {
        let amount = '100';
        it('should allow to forge resource', async function () {
            await this.challenge4.forgeResource(amount);
            expect(
                await this.basicCoin.getBalance(this.challenge4.address)
            ).to.be.bignumber.equal(amount);
        });
    });
});
