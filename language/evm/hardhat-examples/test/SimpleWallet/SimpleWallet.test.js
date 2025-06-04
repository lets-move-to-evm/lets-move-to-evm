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
const SimpleWallet = artifacts.require('SimpleWallet');

contract('SimpleWallet', function (accounts) {
    const [deployer, user1, user2, reclaimer, receiver] = accounts;
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
    let SimpleWalletABI = [
        'function initialize(address owner, address coin)',
        'function deposit(address sender, address owner, uint256 amount)',
        'function withdraw(address sender)',
        'function createTransaction(address owner, address to, uint256 value, string data)',
        'function executeTransaction(address owner, uint64 txId)',
    ];

    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);
    let simpleWalletInterface = new ethers.utils.Interface(SimpleWalletABI);

    before(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.basicCoinTest = await BasicCoinTest.new(this.basicCoin.address, {
            from: deployer,
        });
        this.simpleWallet = await SimpleWallet.new({ from: deployer });

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
            let initializeEncoding = simpleWalletInterface.encodeFunctionData(
                'initialize',
                [deployer, this.basicCoin.address]
            );
            let result = await this.basicCoin.protectionLayer(
                this.simpleWallet.address,
                initializeEncoding,
                { from: deployer }
            );
            console.log('Initialize cost: ', result.receipt.gasUsed);
        });

        it('user 1 should be able to deposit', async function () {
            let depositEncoding = simpleWalletInterface.encodeFunctionData(
                'deposit',
                [user1, deployer, 100]
            );
            let result = await this.basicCoin.protectionLayer(
                this.simpleWallet.address,
                depositEncoding,
                { from: user1 }
            );
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to withdraw', async function () {
            let withdrawEncoding = simpleWalletInterface.encodeFunctionData(
                'withdraw',
                [deployer]
            );
            let result = await this.basicCoin.protectionLayer(
                this.simpleWallet.address,
                withdrawEncoding,
                { from: deployer }
            );
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('user 2 should be able to deposit', async function () {
            let depositEncoding = simpleWalletInterface.encodeFunctionData(
                'deposit',
                [user2, deployer, 200]
            );
            let result = await this.basicCoin.protectionLayer(
                this.simpleWallet.address,
                depositEncoding,
                { from: user2 }
            );
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });

        it('deployer should be able to create a transaction', async function () {
            let createTransactionEncoding =
                simpleWalletInterface.encodeFunctionData('createTransaction', [
                    deployer,
                    user1,
                    100,
                    'ciao',
                ]);
            let result = await this.basicCoin.protectionLayer(
                this.simpleWallet.address,
                createTransactionEncoding,
                { from: deployer }
            );
            console.log('Create transaction cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to execute a transaction', async function () {
            let executeTransactionEncoding =
                simpleWalletInterface.encodeFunctionData('executeTransaction', [
                    deployer,
                    0,
                ]);
            let result = await this.basicCoin.protectionLayer(
                this.simpleWallet.address,
                executeTransactionEncoding,
                { from: deployer }
            );
            console.log('Execute transaction cost: ', result.receipt.gasUsed);
        });
    });
});
