const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const BasicCoin = artifacts.require('BasicCoin');
const BasicCoinTest = artifacts.require('BasicCoinTestV1');

contract('BasicCoin', function (accounts) {
    const [deployer, user1, user2] = accounts;
    let BasicCoinABI = [
        'function protectionLayer(address to, bytes cb)',
        'function register()',
        'function transfer(address to, uint256 amount)',
        'function mintCapability()',
        'function hasMintCapability(address) returns (bool)',
    ];
    let BasicCoinTestABI = [
        'function register(address)',
        'function mintTo(address signer, uint256 amount, address to)',
        'function mint(address signer, uint256 amount)',
        'function transfer(address signer, uint256 amount, address to)',
        'function withdraw(address signer, uint256 amount)',
        'function withdrawAndDeposit(address signer, uint256 amount, address to)',
    ];
    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);

    beforeEach(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.basicCoinTest = await BasicCoinTest.new(this.basicCoin.address, {
            from: deployer,
        });
        let registerEncoding = basicCoinInterface.encodeFunctionData(
            'register',
            []
        );

        let result = await this.basicCoin.protectionLayer(
            this.basicCoin.address,
            registerEncoding,
            { from: user1 }
        );
        console.log('Register cost: ', result.receipt.gasUsed);

        result = await this.basicCoin.protectionLayer(
            this.basicCoin.address,
            registerEncoding,
            { from: user2 }
        );
        console.log('Register cost: ', result.receipt.gasUsed);

        expect(await this.basicCoin.getBalance(user1)).to.be.bignumber.equal(
            '0'
        );
        expect(await this.basicCoin.getBalance(user2)).to.be.bignumber.equal(
            '0'
        );
        let mintToEncoding = basicCoinTestInterface.encodeFunctionData(
            'mintTo',
            [deployer, 10000, user1]
        );

        result = await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            mintToEncoding,
            { from: deployer }
        );
        console.log('MintTo cost: ', result.receipt.gasUsed);
    });

    describe('when everything is set up', function () {
        it('should allow to transfer', async function () {
            let transferEncoding = basicCoinTestInterface.encodeFunctionData(
                'transfer',
                [user1, '1', user2]
            );
            let result = await this.basicCoin.protectionLayer(
                this.basicCoinTest.address,
                transferEncoding,
                { from: user1 }
            );
            console.log('Transfer cost', result.receipt.gasUsed);

            // result = await this.basicCoin.protectionLayer(
            //     this.basicCoinTest.address,
            //     transferEncoding,
            //     { from: user1 }
            // );
            // console.log(result.receipt.gasUsed);

            // result = await this.basicCoin.protectionLayer(
            //     this.basicCoinTest.address,
            //     transferEncoding,
            //     { from: user1 }
            // );
            // console.log(result.receipt.gasUsed);

            // result = await this.basicCoin.protectionLayer(
            //     this.basicCoinTest.address,
            //     transferEncoding,
            //     { from: user1 }
            // );
            // console.log(result.receipt.gasUsed);
        });
    });
});
