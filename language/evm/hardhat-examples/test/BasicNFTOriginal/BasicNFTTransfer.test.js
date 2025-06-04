const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers, Contract } = require('ethers');
const { ZERO_ADDRESS } = constants;

const BasicNFT = artifacts.require('BasicNFTOriginal');
/*
TO BE ADAPTED TO ORIGNAL CONTRACT

contract('BasicNFT', function (accounts) {
    const [deployer, user1, user2] = accounts;
    let BasicNFTABI = [
        'function protectionLayer(address to, bytes cb)',
        'function mintCapability()',
        'function hasMintCapability(address) returns (bool)',
        'function initToken(string name, string uri)',
        'function mint(uint64 tokenId, address to)',
        'function transfer(uint64 tokenId, address to)',
        'function withdraw(uint64 tokenId) returns (uint256)',
        'function deposit(address to, uint256 token)',
        'function register()',
        'function balanceOf(address owner) returns (uint64)',
    ];
    let BasicNFTTestABI = [
        'function initToken(string name, string uri)',
        'function register(address)',
        'function mint(address signer, uint64 tokenId)',
        'function transfer(address signer, uint64 tokenId, address to)',
        'function withdraw(address signer, uint256 amount)',
        'function withdrawAndDeposit(address signer, uint256 amount, address to)',
    ];
    let encoder = new ethers.utils.AbiCoder();
    let basicNFTInterface = new ethers.utils.Interface(BasicNFTABI);
    let basicNFTTestInterface = new ethers.utils.Interface(BasicNFTTestABI);

    beforeEach(async function () {
        this.basicNFT = await BasicNFT.new({ from: deployer });
        this.basicNFTTest = await BasicNFTTest.new(this.basicNFT.address, {
            from: deployer,
        });

        let initTokenEncoding = basicNFTInterface.encodeFunctionData(
            'initToken',
            ['BasicNFT', 'https://basicnft.com/']
        );

        let result = await this.basicNFT.protectionLayer(
            this.basicNFT.address,
            initTokenEncoding,
            { from: deployer }
        );
        console.log('InitToken cost: ', result.receipt.gasUsed);

        let registerEncoding = basicNFTInterface.encodeFunctionData(
            'register',
            []
        );

        result = await this.basicNFT.protectionLayer(
            this.basicNFT.address,
            registerEncoding,
            { from: user1 }
        );
        console.log('Register cost: ', result.receipt.gasUsed);

        expect(await this.basicNFT.balanceOf(user1)).to.be.bignumber.equal('0');
        expect(await this.basicNFT.balanceOf(user2)).to.be.bignumber.equal('0');

        let mintEncoding = basicNFTTestInterface.encodeFunctionData('mint', [
            deployer,
            2,
        ]);

        result = await this.basicNFT.protectionLayer(
            this.basicNFTTest.address,
            mintEncoding,
            { from: deployer }
        );

        console.log('Mint cost: ', result.receipt.gasUsed);
    });

    describe('when everything is set up', function () {
        it('should allow to transfer', async function () {
            let transferEncoding = basicNFTTestInterface.encodeFunctionData(
                'transfer',
                [deployer, 2, user1]
            );

            let result = await this.basicNFT.protectionLayer(
                this.basicNFTTest.address,
                transferEncoding,
                { from: deployer }
            );

            console.log('Transfer cost', result.receipt.gasUsed);
        });
    });
});
*/
