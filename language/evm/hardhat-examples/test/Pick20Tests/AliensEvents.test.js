const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const AliensEvents = artifacts.require('AliensEvents');
const AliensEventsTest = artifacts.require('AliensEventsTest');

contract('AliensEvents', function (accounts) {
    const [deployer, user1, user2] = accounts;
    let AliensEventsABI = ['function protectionLayer(address to, bytes cb)'];
    let AliensEventsTestABI = [
        'function newWithdrawEventTest(address signer)',
        'function newSetReferrerEventTest(address signer)',
        'function newSetMintPriceEventTest(address signer)',
    ];

    let encoder = new ethers.utils.AbiCoder();
    let aliensEventsInterface = new ethers.utils.Interface(AliensEventsABI);
    let aliensEventsTestInterface = new ethers.utils.Interface(
        AliensEventsTestABI
    );

    before(async function () {
        this.aliensEvents = await AliensEvents.new({ from: deployer });
        this.aliensEventsTest = await AliensEventsTest.new(
            this.aliensEvents.address,
            {
                from: deployer,
            }
        );
    });
    describe('AliensEvents', function () {
        it('should call newWithdrawEvent', async function () {
            let newWithdrawEventEncoding =
                aliensEventsTestInterface.encodeFunctionData(
                    'newWithdrawEventTest',
                    [user1]
                );
            let result = await this.aliensEvents.protectionLayer(
                this.aliensEventsTest.address,
                newWithdrawEventEncoding,
                { from: user1 }
            );
            console.log('New withdraw event cost: ', result.receipt.gasUsed);
        });
        it('should call newSetReferrerEvent', async function () {
            let newSetReferrerEventEncoding =
                aliensEventsTestInterface.encodeFunctionData(
                    'newSetReferrerEventTest',
                    [user1]
                );
            let result = await this.aliensEvents.protectionLayer(
                this.aliensEventsTest.address,
                newSetReferrerEventEncoding,
                { from: user1 }
            );
            console.log(
                'New set referrer event cost: ',
                result.receipt.gasUsed
            );
        });
        it('should call newSetMintPriceEvent', async function () {
            let newSetMintPriceEventEncoding =
                aliensEventsTestInterface.encodeFunctionData(
                    'newSetMintPriceEventTest',
                    [user1]
                );
            let result = await this.aliensEvents.protectionLayer(
                this.aliensEventsTest.address,
                newSetMintPriceEventEncoding,
                { from: user1 }
            );
            console.log(
                'New set mint price event cost: ',
                result.receipt.gasUsed
            );
        });
    });
});
