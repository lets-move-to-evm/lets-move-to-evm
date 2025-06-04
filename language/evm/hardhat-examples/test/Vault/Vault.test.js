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
const Vault = artifacts.require('Vault');

contract('Vault', function (accounts) {
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
    let VaultABI = [
        'function init(address owner, address recovery, uint256 waitTime, address basicCoin)',
        'function deposit(address owner, uint256 amount)',
        'function withdraw(address owner, uint256 amount, address receiver)',
        'function finalize(address owner)',
        'function cancel(address owner, address recovery)',
    ];

    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);
    let vaultInterface = new ethers.utils.Interface(VaultABI);

    before(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.basicCoinTest = await BasicCoinTest.new(this.basicCoin.address, {
            from: deployer,
        });
        this.vault = await Vault.new({ from: deployer });

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
            let initEncoding = vaultInterface.encodeFunctionData('init', [
                deployer,
                user1,
                1000,
                this.basicCoin.address,
            ]);
            let result = await this.basicCoin.protectionLayer(
                this.vault.address,
                initEncoding,
                { from: deployer }
            );
            console.log('Init cost: ', result.receipt.gasUsed);
        });

        it('deployer should be able to deposit', async function () {
            let depositEncoding = vaultInterface.encodeFunctionData('deposit', [
                deployer,
                300,
            ]);
            let result = await this.basicCoin.protectionLayer(
                this.vault.address,
                depositEncoding,
                { from: deployer }
            );
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to withdraw', async function () {
            let withdrawEncoding = vaultInterface.encodeFunctionData(
                'withdraw',
                [deployer, 100, user1]
            );
            let result = await this.basicCoin.protectionLayer(
                this.vault.address,
                withdrawEncoding,
                { from: deployer }
            );
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to finalize', async function () {
            // increase time
            await time.increase(1000);
            let finalizeEncoding = vaultInterface.encodeFunctionData(
                'finalize',
                [deployer]
            );
            let result = await this.basicCoin.protectionLayer(
                this.vault.address,
                finalizeEncoding,
                { from: deployer }
            );
            console.log('Finalize cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to withdraw', async function () {
            let withdrawEncoding = vaultInterface.encodeFunctionData(
                'withdraw',
                [deployer, 100, user1]
            );
            let result = await this.basicCoin.protectionLayer(
                this.vault.address,
                withdrawEncoding,
                { from: deployer }
            );
            console.log('Withdraw cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to cancel', async function () {
            let cancelEncoding = vaultInterface.encodeFunctionData('cancel', [
                deployer,
                user1,
            ]);
            let result = await this.basicCoin.protectionLayer(
                this.vault.address,
                cancelEncoding,
                { from: deployer }
            );
            console.log('Cancel cost: ', result.receipt.gasUsed);
        });
    });
});
