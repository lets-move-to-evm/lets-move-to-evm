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
const Vesting = artifacts.require('Vesting');

contract('Vesting', function (accounts) {
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

    let VestingABI = [
        'function init(address owner, address beneficiary, address coinAddress, uint256 start, uint256 duration, uint256 amount)',
        'function release()',
        'function releasable() returns (uint256)',
        'function vestedAmount() returns (uint256)',
        'function vestingSchedule(uint256 totalAmount, uint256 currentTime) returns (uint256)',
    ];
    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);
    let vestingInterface = new ethers.utils.Interface(VestingABI);

    before(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
        this.basicCoinTest = await BasicCoinTest.new(this.basicCoin.address, {
            from: deployer,
        });
        this.vesting = await Vesting.new({ from: deployer });

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
            let initEncoding = vestingInterface.encodeFunctionData('init', [
                deployer,
                user1,
                this.basicCoin.address,
                0,
                1000,
                1000,
            ]);
            let result = await this.basicCoin.protectionLayer(
                this.vesting.address,
                initEncoding,
                { from: deployer }
            );
            console.log('Init cost: ', result.receipt.gasUsed);
        });
        it('should be able to release', async function () {
            let releaseEncoding = vestingInterface.encodeFunctionData(
                'release',
                []
            );
            let result = await this.basicCoin.protectionLayer(
                this.vesting.address,
                releaseEncoding,
                { from: user1 }
            );
            console.log('Release cost: ', result.receipt.gasUsed);
        });
    });
});
