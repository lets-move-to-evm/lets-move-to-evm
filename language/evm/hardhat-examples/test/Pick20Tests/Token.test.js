const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Token = artifacts.require('Token2');

contract('Token', function (accounts) {
    const [deployer, user1, user2] = accounts;

    let TokenABI = [
        'function protectionLayer(address to, bytes cb)',
        'function initialize()',
        'function mint(uint64)',
        'function transfer(address,uint64)',
        'function balanceOf(address) returns (uint64)',
    ];
    let tokenInterface = new ethers.utils.Interface(TokenABI);

    before(async function () {
        this.token = await Token.new({ from: deployer });
    });

    describe('Token', function () {
        it('should initialize', async function () {
            let initializeEncoding = tokenInterface.encodeFunctionData(
                'initialize',
                []
            );
            let result = await this.token.protectionLayer(
                this.token.address,
                initializeEncoding,
                { from: user1 }
            );
            console.log('Initialize cost: ', result.receipt.gasUsed);
        });
        it('should initialize', async function () {
            let initializeEncoding = tokenInterface.encodeFunctionData(
                'initialize',
                []
            );
            let result = await this.token.protectionLayer(
                this.token.address,
                initializeEncoding,
                { from: user2 }
            );
            console.log('Initialize cost: ', result.receipt.gasUsed);
        });
        it('should mint', async function () {
            let mintEncoding = tokenInterface.encodeFunctionData('mint', [100]);
            let result = await this.token.protectionLayer(
                this.token.address,
                mintEncoding,
                { from: user1 }
            );
            console.log('Mint cost: ', result.receipt.gasUsed);
        });
        it('should transfer', async function () {
            let transferEncoding = tokenInterface.encodeFunctionData(
                'transfer',
                [user2, 100]
            );
            let result = await this.token.protectionLayer(
                this.token.address,
                transferEncoding,
                { from: user1 }
            );
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
