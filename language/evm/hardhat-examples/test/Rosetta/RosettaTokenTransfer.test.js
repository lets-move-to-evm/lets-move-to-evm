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
const { toNumber } = require('web3-utils');

const RosettaTokenTransfer = artifacts.require('RosettaTokenTransfer');
const ERC20Token = artifacts.require('ERC20Mock_Sol');

contract('RosettaTokenTransfer', async function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.erc20Token = await ERC20Token.new(
            'Test Token',
            'TT',
            deployer,
            2000,
            { from: deployer }
        );
        this.rosettaTokenTransfer = await RosettaTokenTransfer.new(
            user2,
            this.erc20Token.address,
            { from: user1 }
        );
        await this.erc20Token.mint(user1, 1000, { from: deployer });
        await this.erc20Token.approveInternal(
            user1,
            this.rosettaTokenTransfer.address,
            1000,
            { from: deployer }
        );
    });
    describe('After deployment', async function () {
        it('User1 could deposit', async function () {
            let result = await this.rosettaTokenTransfer.deposit(100, {
                from: user1,
            });
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('User2 could withdraw', async function () {
            let result = await this.rosettaTokenTransfer.withdraw(100, {
                from: user2,
            });
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
    });
});
