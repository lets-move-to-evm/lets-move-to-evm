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

const BasicCoin = artifacts.require('BasicCoin');
const BasicCoinTest = artifacts.require('BasicCoinTestV1');
const TokenTransfer = artifacts.require('TokenTransfer');

contract('TokenTransfer', function (accounts) {
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
        'function withdraw(address signer, uint256 amount)',
        'function withdrawAndDeposit(address signer, uint256 amount, address to)',
    ];
    let TokenTransferABI = [
        'function init(address basicCoin, address owner, address recipient)',
        'function deposit(address sender, uint256 amount)',
        'function withdraw(address sender, address owner, uint256 amount)',
    ];

    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);
    let tokenTransferInterface = new ethers.utils.Interface(TokenTransferABI);

    before(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.basicCoinTest = await BasicCoinTest.new(this.basicCoin.address, {
            from: deployer,
        });
        this.tokenTransfer = await TokenTransfer.new({ from: deployer });

        // register the deployer
        let registerEncoding = basicCoinTestInterface.encodeFunctionData(
            'register',
            [deployer]
        );
        await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            registerEncoding,
            { from: deployer }
        );

        // mint to deployer
        let mintToEncoding = basicCoinTestInterface.encodeFunctionData(
            'mintTo',
            [deployer, 2000, deployer]
        );
        await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            mintToEncoding,
            { from: deployer }
        );

        // Register user1
        registerEncoding = basicCoinTestInterface.encodeFunctionData(
            'register',
            [user1]
        );
        await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            registerEncoding,
            { from: user1 }
        );
        // Mint to user 1
        mintToEncoding = basicCoinTestInterface.encodeFunctionData('mintTo', [
            deployer,
            2000,
            user1,
        ]);
        await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            mintToEncoding,
            { from: deployer }
        );

        // Register user2
        registerEncoding = basicCoinTestInterface.encodeFunctionData(
            'register',
            [user2]
        );
        await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            registerEncoding,
            { from: user2 }
        );
        // Mint to user 2
        mintToEncoding = basicCoinTestInterface.encodeFunctionData('mintTo', [
            deployer,
            2000,
            user2,
        ]);
        await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            mintToEncoding,
            { from: deployer }
        );
    });
    describe('when everyting is set up', function () {
        before(async function () {
            let initEncoding = tokenTransferInterface.encodeFunctionData(
                'init',
                [this.basicCoin.address, deployer, user1]
            );
            let result = await this.basicCoin.protectionLayer(
                this.tokenTransfer.address,
                initEncoding,
                { from: deployer }
            );
            console.log('Init cost: ', result.receipt.gasUsed);
        });

        it('deployer should be able to deposit', async function () {
            let depositEncoding = tokenTransferInterface.encodeFunctionData(
                'deposit',
                [deployer, 100]
            );
            let result = await this.basicCoin.protectionLayer(
                this.tokenTransfer.address,
                depositEncoding,
                { from: deployer }
            );
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });

        it('user 1 should be able to withdraw', async function () {
            let withdrawEncoding = tokenTransferInterface.encodeFunctionData(
                'withdraw',
                [user1, deployer, 100]
            );
            let result = await this.basicCoin.protectionLayer(
                this.tokenTransfer.address,
                withdrawEncoding,
                { from: user1 }
            );
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
    });
});
