const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const DoNothing = artifacts.require('DoNothing');
const DoNothingSol = artifacts.require('DoNothingSol');

let DoNothingSolABI = ['function doNothing()'];
let doNothingSolInterface = new ethers.utils.Interface(DoNothingSolABI);

contract('DoNothing', function (accounts) {
    const [deployer, user1, user2] = accounts;
    describe('when everything is set up', function () {
        it('should do nothing', async function () {
            this.doNothing = await DoNothing.new();
            this.doNothingSol = await DoNothingSol.new();

            let doNothingEncoding = doNothingSolInterface.encodeFunctionData(
                'doNothing',
                []
            );
            await this.doNothing.protectionLayer(
                this.doNothingSol.address,
                doNothingEncoding
            );
        });
    });
});
