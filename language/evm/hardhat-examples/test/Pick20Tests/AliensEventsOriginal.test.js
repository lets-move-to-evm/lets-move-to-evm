const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const AliensEvents = artifacts.require('AliensEventsOriginal');

contract('AliensEventsOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.aliensEvents = await AliensEvents.new({ from: deployer });
    });
    describe('AliensEventsOrginal', function () {
        it('should call newWithdrawEvent', async function () {
            let result = await this.aliensEvents.newWithdrawEvent(
                this.aliensEvents.address,
                0,
                0,
                { from: user1 }
            );
            console.log('New withdraw event cost: ', result.receipt.gasUsed);
        });
        it('should call newSetReferrerEvent', async function () {
            let result = await this.aliensEvents.newSetReferrerEvent(
                'ciao',
                this.aliensEvents.address,
                0,
                { from: user1 }
            );
            console.log(
                'New set referrer event cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call newSetMintPriceEvent', async function () {
            let result = await this.aliensEvents.newSetMintPriceEvent(0, 0, {
                from: user1,
            });
            console.log(
                'New set mint price event cost: ',
                result.receipt.gasUsed
            );
        });
    });
});
