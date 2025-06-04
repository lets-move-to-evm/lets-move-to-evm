const {
    BN,
    constants,
    expectEvent,
    expectRevert,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const BasicCoin = artifacts.require('BasicCoin');
const BasicCoinTest = artifacts.require('BasicCoinTestV1');
const ExternalCallCoin = artifacts.require('ExternalCallCoin');

contract('ExternalCallCoin', function (accounts) {
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
    let ExternalCallCoinABI = [
        'function bid(address signer, uint256 amount)',
        'function start(address signer, address coinAddress, uint256 base)',
    ];
    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);
    let externalCallCoinInterface = new ethers.utils.Interface(
        ExternalCallCoinABI
    );

    before(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.basicCoinTest = await BasicCoinTest.new(this.basicCoin.address, {
            from: deployer,
        });
        this.externalCallcoin = await ExternalCallCoin.new();

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
        let mintToEncoding = basicCoinTestInterface.encodeFunctionData(
            'mintTo',
            [deployer, 20, user1]
        );
        await this.basicCoin.protectionLayer(
            this.basicCoinTest.address,
            mintToEncoding,
            { from: deployer }
        );

        // Start auction
        let startEncoding = externalCallCoinInterface.encodeFunctionData(
            'start',
            [deployer, this.basicCoin.address, 0]
        );

        await this.basicCoin.protectionLayer(
            this.externalCallcoin.address,
            startEncoding,
            { from: deployer }
        );
    });
    describe('when everyting is set up', function () {
        it('user 1 should be able to bid', async function () {
            let bidEncoding = externalCallCoinInterface.encodeFunctionData(
                'bid',
                [user1, 10]
            );
            await this.basicCoin.protectionLayer(
                this.externalCallcoin.address,
                bidEncoding,
                { from: user1 }
            );
        });
    });
});
