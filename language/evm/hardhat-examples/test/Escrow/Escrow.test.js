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
const Escrow = artifacts.require('Escrow');

contract('Escrow', function (accounts) {
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
    let EscrowABI = [
        'function create(address coinAddress, address seller, address buyer, uint256 amount)',
        'function deposit(address buyer, uint256 amount)',
        'function pay(address)',
        'function refund(address)',
    ];

    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);
    let escrowInterface = new ethers.utils.Interface(EscrowABI);

    before(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.basicCoinTest = await BasicCoinTest.new(this.basicCoin.address, {
            from: deployer,
        });

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

        // Mint to deployer
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
        beforeEach(async function () {
            this.escrow = await Escrow.new({ from: deployer });

            let createEncoding = escrowInterface.encodeFunctionData('create', [
                this.basicCoin.address,
                user1,
                user2,
                1000,
            ]);

            let result = await this.basicCoin.protectionLayer(
                this.escrow.address,
                createEncoding,
                { from: user1 }
            );
            console.log('Create cost: ', result.receipt.gasUsed);

            let depositEncoding = escrowInterface.encodeFunctionData(
                'deposit',
                [user2, 1000]
            );
            result = await this.basicCoin.protectionLayer(
                this.escrow.address,
                depositEncoding,
                { from: user2 }
            );
            console.log('Deposit cost: ', result.receipt.gasUsed);
        });
        it('user 2 should be able to pay', async function () {
            let payEncoding = escrowInterface.encodeFunctionData('pay', [
                user2,
            ]);
            let result = await this.basicCoin.protectionLayer(
                this.escrow.address,
                payEncoding,
                { from: user2 }
            );
            console.log('Pay cost: ', result.receipt.gasUsed);
        });
        it('user 1 should be able to refund', async function () {
            let refundEncoding = escrowInterface.encodeFunctionData('refund', [
                user1,
            ]);
            let result = await this.basicCoin.protectionLayer(
                this.escrow.address,
                refundEncoding,
                { from: user1 }
            );
            console.log('Refund cost: ', result.receipt.gasUsed);
        });
    });
});
