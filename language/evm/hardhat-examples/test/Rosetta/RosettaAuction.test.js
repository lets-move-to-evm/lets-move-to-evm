const {
    BN,
    constants,
    expectEvent,
    expectRevert,
    time,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const RosettaAuction = artifacts.require('RosettaAuction');

contract('RosettaAuction', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.rosettaAuction = await RosettaAuction.new('Sold Object', 10, {
            from: deployer,
        });
    });
    describe('After deployment', function () {
        it('Seller could start the auction', async function () {
            let result = await this.rosettaAuction.start(
                time.duration.days(1),
                {
                    from: deployer,
                }
            );
            console.log('Start cost: ', result.receipt.gasUsed);
        });
        it('User1 could bid', async function () {
            let result = await this.rosettaAuction.bid({
                from: user1,
                value: 1000,
            });
            console.log('Bid cost: ', result.receipt.gasUsed);
        });
        it('User2 could bid', async function () {
            let result = await this.rosettaAuction.bid({
                from: user2,
                value: 2000,
            });
            console.log('Bid cost: ', result.receipt.gasUsed);
        });
        it('User1 could bid again', async function () {
            let result = await this.rosettaAuction.bid({
                from: user1,
                value: 3000,
            });
            console.log('Bid cost: ', result.receipt.gasUsed);
        });
        it('User1 could withdraw', async function () {
            let result = await this.rosettaAuction.withdraw({
                from: user1,
            });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('Seller could end the auction', async function () {
            // forward VM time
            await time.increase(time.duration.days(1));
            let result = await this.rosettaAuction.end({
                from: deployer,
            });
            console.log('End cost: ', result.receipt.gasUsed);
        });
    });
});
