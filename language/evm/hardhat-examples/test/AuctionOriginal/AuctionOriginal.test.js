const {
    BN,
    constants,
    expectEvent,
    expectRevert,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const AuctionOriginal = artifacts.require('AuctionOriginal');
const BasicCoinOriginal = artifacts.require('BasicCoinOriginal');

contract('AuctionOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.basicCoin = await BasicCoinOriginal.new({ from: deployer });

        this.auction = await AuctionOriginal.new({ from: deployer });

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

        // Start auction
        let result = await this.auction.start(this.basicCoin.address, 0, {
            from: deployer,
        });
        console.log('Start cost', result.receipt.gasUsed);
    });
    describe('when everyting is set up', function () {
        it('user 1 should be able to bid', async function () {
            let result = await this.auction.bid(10, { from: user1 });
            console.log('Bid cost', result.receipt.gasUsed);
        });
        it('user 2 should be able to bid', async function () {
            let result = await this.auction.bid(11, { from: user2 });
            console.log('Bid cost', result.receipt.gasUsed);
        });
        it('auctioneer should be able to end the auction', async function () {
            let result = await this.auction.end({ from: deployer });
            console.log('End cost', result.receipt.gasUsed);
        });
        describe('after the auction is ended', function () {
            it('user 1 should not be able to bid', async function () {
                await expectRevert(
                    this.auction.bid(12, { from: user1 }),
                    '0xffffffffffffffff'
                );
            });
            xit('user 2 should not be able to bid', async function () {
                let bidEncoding = auctionInterface.encodeFunctionData('bid', [
                    user2,
                    11,
                ]);
                await expectRevert(
                    this.basicCoin.protectionLayer(
                        this.auction.address,
                        bidEncoding,
                        { from: user2 }
                    ),
                    'Transaction reverted without a reason string'
                );
            });
        });
    });
});
