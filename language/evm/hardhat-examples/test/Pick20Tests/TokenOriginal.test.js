const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const TokenOriginal = artifacts.require('TokenOriginal');

contract('TokenOriginal', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.token = await TokenOriginal.new({ from: deployer });
    });

    describe('TokenOriginal', function () {
        it('should initialize', async function () {
            let result = await this.token.initialize({ from: user1 });
            console.log('Initialize cost: ', result.receipt.gasUsed);
        });
        it('should initialize', async function () {
            let result = await this.token.initialize({ from: user2 });
            console.log('Initialize cost: ', result.receipt.gasUsed);
        });
        it('should mint', async function () {
            let result = await this.token.mint(100, { from: user1 });
            console.log('Mint cost: ', result.receipt.gasUsed);
        });
        it('should transfer', async function () {
            let result = await this.token.transfer(user2, 50, {
                from: user1,
            });
            console.log('Transfer cost: ', result.receipt.gasUsed);
        });
        it('should get balance', async function () {
            let result = await this.token.balanceOf(user2, {
                from: user1,
            });
            console.log('Balance cost: ', result.receipt.gasUsed);
        });
    });
});
