const {
    BN,
    constants,
    expectEvent,
    expectRevert,
    time,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { toNumber } = require('web3-utils');

const { ZERO_ADDRESS } = constants;

const BasicCoinOriginal = artifacts.require('BasicCoinOriginal');
const BetOriginal = artifacts.require('BetOriginal');

contract('BetOriginal', function (accounts) {
    const [deployer, user1, user2, oracle] = accounts;

    before(async function () {
        this.basicCoin = await BasicCoinOriginal.new({ from: deployer });

        // register the deployer
        await this.basicCoin.register({ from: deployer });

        // Register user1
        await this.basicCoin.register({ from: user1 });
        // Mint to user 1
        await this.basicCoin.mintTo(200, user1, { from: deployer });

        // Register user2
        await this.basicCoin.register({ from: user2 });

        // Mint to user 2
        await this.basicCoin.mintTo(200, user2, { from: deployer });
    });
    describe('when everyting is set up', function () {
        before(async function () {
            const timestamp = await time.latest();
            const deadline = toNumber(timestamp) + 1000;
            this.bet = await BetOriginal.new(
                user1,
                user2,
                oracle,
                10,
                deadline,
                this.basicCoin.address,
                { from: deployer }
            );
        });
        it('user 1 should be able to join', async function () {
            let result = await this.bet.join(10, { from: user1 });
            console.log('Join cost: ', result.receipt.gasUsed);
        });
        it('user 2 should be able to join', async function () {
            let result = await this.bet.join(10, { from: user2 });
            console.log('Join cost: ', result.receipt.gasUsed);
        });
        describe('after players have joined', function () {
            beforeEach(async function () {
                const timestamp = await time.latest();
                const deadline = toNumber(timestamp) + 1000;

                this.bet = await BetOriginal.new(
                    user1,
                    user2,
                    oracle,
                    10,
                    deadline,
                    this.basicCoin.address,
                    { from: deployer }
                );
                await this.bet.join(10, { from: user1 });
                await this.bet.join(10, { from: user2 });
            });

            it('oracle should be able to set winner', async function () {
                let result = await this.bet.win(user1, { from: oracle });
                console.log('Win cost: ', result.receipt.gasUsed);
            });
            it('after some time the bet should timeout', async function () {
                await time.increase(2000);
                let result = await this.bet.timeout({ from: oracle });
                console.log('Timeout cost: ', result.receipt.gasUsed);
            });
        });
        // describe('after players have joined', function () {
        //     xit('user 1 should not be able to bid', async function () {
        //         let bidEncoding = betInterface.encodeFunctionData('join', [
        //             user1,
        //             10,
        //         ]);
        //         await expectRevert(
        //             this.basicCoin.protectionLayer(
        //                 this.bet.address,
        //                 bidEncoding,
        //                 { from: user1 }
        //             ),
        //             'Transaction reverted without a reason string'
        //         );
        //     });
        //     xit('user 2 should not be able to bid', async function () {
        //         let bidEncoding = betInterface.encodeFunctionData('bid', [
        //             user2,
        //             11,
        //         ]);
        //         await expectRevert(
        //             this.basicCoin.protectionLayer(
        //                 this.bet.address,
        //                 bidEncoding,
        //                 { from: user2 }
        //             ),
        //             'Transaction reverted without a reason string'
        //         );
        //     });
        // });
    });
});
