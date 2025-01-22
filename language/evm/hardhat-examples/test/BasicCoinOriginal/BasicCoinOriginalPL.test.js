const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const BasicCoin = artifacts.require('BasicCoinOriginal');

contract('BasicCoin', function (accounts) {
    const [deployer, user1, user2] = accounts;

    beforeEach(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
    });

    describe('when everything is set up', function () {
        it('should do nothing', async function () {
            let result = await this.basicCoin.doNothing({
                from: user1,
            });
        });
    });
});
