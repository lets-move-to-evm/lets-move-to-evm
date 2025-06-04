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
const Pricebet = artifacts.require('Pricebet');
const Exchange = artifacts.require('Exchange');

contract('Pricebet', function (accounts) {
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
    let PricebetABI = [
        'function create(address coinAddress, address exchangeAddress, address owner, uint256 deadline, uint256 exchangeRate, uint256 initialPot)',
        'function join(address participant, uint256 bet)',
        'function win(address player)',
        'function timeout()',
    ];

    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);
    let pricebetInterface = new ethers.utils.Interface(PricebetABI);

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
            this.pricebet = await Pricebet.new({ from: deployer });
            this.exchange = await Exchange.new({ from: deployer });

            let blockNumber = await time.latestBlock();
            let deadline = toNumber(blockNumber) + 100;

            let exchangeRate = 2;
            // Create a new bet
            let createEncoding = pricebetInterface.encodeFunctionData(
                'create',
                [
                    this.basicCoin.address,
                    this.exchange.address,
                    deployer,
                    deadline,
                    exchangeRate,
                    1000,
                ]
            );
            let result = await this.basicCoin.protectionLayer(
                this.pricebet.address,
                createEncoding,
                { from: deployer }
            );

            // Cost of creating the bet
            console.log('Create cost: ', result.receipt.gasUsed);

            let joinEncoding = pricebetInterface.encodeFunctionData('join', [
                user1,
                1000,
            ]);
            result = await this.basicCoin.protectionLayer(
                this.pricebet.address,
                joinEncoding,
                { from: user1 }
            );
            // Cost of joining the bet
            console.log('Join cost: ', result.receipt.gasUsed);
        });
        it('user 1 should be able to win the bet', async function () {
            let winEncoding = pricebetInterface.encodeFunctionData('win', [
                user1,
            ]);
            let result = await this.basicCoin.protectionLayer(
                this.pricebet.address,
                winEncoding,
                { from: user1 }
            );
            // Cost of winning the bet
            console.log('Win cost: ', result.receipt.gasUsed);
        });
        it('deployer should be able to timeout the bet', async function () {
            // Increase the block number to simulate the timeout
            await time.advanceBlockTo(
                toNumber(await time.latestBlock()) + 1000
            );

            let timeoutEncoding = pricebetInterface.encodeFunctionData(
                'timeout',
                []
            );
            let result = await this.basicCoin.protectionLayer(
                this.pricebet.address,
                timeoutEncoding,
                { from: deployer }
            );
            // Cost of timing out the bet
            console.log('Timeout cost: ', result.receipt.gasUsed);
        });
    });
});
