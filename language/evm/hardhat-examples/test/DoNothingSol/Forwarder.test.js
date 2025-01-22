const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const DoNothingSol = artifacts.require('DoNothingSol');
const Forwarder = artifacts.require('Forwarder');

contract('DoNothingSol', function (accounts) {
    const [deployer, user1, user2] = accounts;

    describe('when everything is set up', function () {
        it('should do nothing', async function () {
            this.doNothingSol = await DoNothingSol.new();
            this.forwarder = await Forwarder.new(this.doNothingSol.address);
            await this.forwarder.forward();
        });
    });
});
