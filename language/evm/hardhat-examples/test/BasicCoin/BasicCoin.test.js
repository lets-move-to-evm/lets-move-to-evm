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
        'function withdraw(address signer, uint256 amount)',
        'function withdrawAndDeposit(address signer, uint256 amount, address to)',
    ];
    let encoder = new ethers.utils.AbiCoder();
    let basicCoinInterface = new ethers.utils.Interface(BasicCoinABI);
    let basicCoinTestInterface = new ethers.utils.Interface(BasicCoinTestABI);

    beforeEach(async function () {
        this.basicCoin = await BasicCoin.new({ from: deployer });
    });

    describe('when deployed', function () {
        it('deployer should have mint capability', async function () {
            let hasMintCap = await this.basicCoin.hasMintCapability(deployer);
            expect(hasMintCap).to.be.equal(true);
        });
    });

    describe('when protection layer is invoked on itself', function () {
        it('should allow to register', async function () {
            let registerEncoding = basicCoinInterface.encodeFunctionData(
                'register',
                []
            );
            await this.basicCoin.protectionLayer(
                this.basicCoin.address,
                registerEncoding,
                { from: user1 }
            );
            expect(
                await this.basicCoin.getBalance(user1)
            ).to.be.bignumber.equal('0');
        });
        it('should not allow to register twice', async function () {
            let registerEncoding = basicCoinInterface.encodeFunctionData(
                'register',
                []
            );
            await this.basicCoin.protectionLayer(
                this.basicCoin.address,
                registerEncoding,
                { from: user1 }
            );
            await expectRevert(
                this.basicCoin.protectionLayer(
                    this.basicCoin.address,
                    registerEncoding,
                    { from: user1 }
                ),
                'Transaction reverted without a reason string'
            );
        });
        it('should not allow to transfer if not enough money', async function () {
            let registerEncoding = basicCoinInterface.encodeFunctionData(
                'register',
                []
            );
            let transferEncoding = basicCoinInterface.encodeFunctionData(
                'transfer',
                [user1, 10]
            );
            await this.basicCoin.protectionLayer(
                this.basicCoin.address,
                registerEncoding,
                { from: deployer }
            );
            await this.basicCoin.protectionLayer(
                this.basicCoin.address,
                registerEncoding,
                { from: user1 }
            );
            await expectRevert(
                this.basicCoin.protectionLayer(
                    this.basicCoin.address,
                    transferEncoding,
                    { from: deployer }
                ),
                'Transaction reverted without a reason string'
            );

            expect(
                await this.basicCoin.getBalance(user1)
            ).to.be.bignumber.equal('0');
        });
        it('should find deployer mint capability', async function () {
            let mintEncoding = basicCoinInterface.encodeFunctionData(
                'mintCapability',
                []
            );
            await this.basicCoin.protectionLayer(
                this.basicCoin.address,
                mintEncoding,
                { from: deployer }
            );
        });
    });
    describe('when protection layer is invoked on external contract', function () {
        beforeEach(async function () {
            this.basicCoinTest = await BasicCoinTest.new(
                this.basicCoin.address,
                { from: deployer }
            );
        });
        it('should allow to register', async function () {
            let registerEncoding = basicCoinTestInterface.encodeFunctionData(
                'register',
                [user1]
            );
            await this.basicCoin.protectionLayer(
                this.basicCoinTest.address,
                registerEncoding,
                { from: user1 }
            );
            expect(
                await this.basicCoin.getBalance(user1)
            ).to.be.bignumber.equal('0');
        });
        it('should allow to mint', async function () {
            let mintEncoding = basicCoinTestInterface.encodeFunctionData(
                'mint',
                [deployer, 10]
            );
            await this.basicCoin.protectionLayer(
                this.basicCoinTest.address,
                mintEncoding,
                { from: deployer }
            );
        });
        describe('when user is registered', function () {
            beforeEach(async function () {
                let registerEncoding =
                    basicCoinTestInterface.encodeFunctionData('register', [
                        user1,
                    ]);
                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    registerEncoding,
                    { from: user1 }
                );
            });

            it('should be able to withdraw zero amount', async function () {
                let withdrawEncoding =
                    basicCoinTestInterface.encodeFunctionData('withdraw', [
                        user1,
                        0,
                    ]);
                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    withdrawEncoding,
                    { from: user1 }
                );
                expect(
                    await this.basicCoin.getBalance(user1)
                ).to.be.bignumber.equal('0');
            });

            it('should not be able to withdraw more than zero', async function () {
                let withdrawEncoding =
                    basicCoinTestInterface.encodeFunctionData('withdraw', [
                        user1,
                        10,
                    ]);
                await expectRevert(
                    this.basicCoin.protectionLayer(
                        this.basicCoinTest.address,
                        withdrawEncoding,
                        { from: user1 }
                    ),
                    'Transaction reverted without a reason string'
                );
            });

            it('deployer should mint and deposit to a registered user', async function () {
                let mintToEncoding = basicCoinTestInterface.encodeFunctionData(
                    'mintTo',
                    [deployer, 10, user1]
                );

                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    mintToEncoding,
                    { from: deployer }
                );
                expect(
                    await this.basicCoin.getBalance(user1)
                ).to.be.bignumber.equal('10');
            });
        });
        describe('when user is registered and has money', function () {
            beforeEach(async function () {
                let registerEncoding =
                    basicCoinTestInterface.encodeFunctionData('register', [
                        user1,
                    ]);
                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    registerEncoding,
                    { from: user1 }
                );

                let mintToEncoding = basicCoinTestInterface.encodeFunctionData(
                    'mintTo',
                    [deployer, 10, user1]
                );

                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    mintToEncoding,
                    { from: deployer }
                );
            });
            it('should be able to withdraw and deposit', async function () {
                let withdrawDepositEncoding =
                    basicCoinTestInterface.encodeFunctionData(
                        'withdrawAndDeposit',
                        [user1, 5, user1]
                    );
                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    withdrawDepositEncoding,
                    { from: user1 }
                );
                expect(
                    await this.basicCoin.getBalance(user1)
                ).to.be.bignumber.equal('10');
            });
            it('should not be able to withdraw more than balance', async function () {
                let withdrawDepositEncoding =
                    basicCoinTestInterface.encodeFunctionData(
                        'withdrawAndDeposit',
                        [user1, 15, user1]
                    );
                await expectRevert(
                    this.basicCoin.protectionLayer(
                        this.basicCoinTest.address,
                        withdrawDepositEncoding,
                        { from: user1 }
                    ),
                    'Transaction reverted without a reason string'
                );
            });
            it('should be able to withdraw and deposit to another user', async function () {
                let withdrawDepositEncoding =
                    basicCoinTestInterface.encodeFunctionData(
                        'withdrawAndDeposit',
                        [user1, 5, user2]
                    );
                let registerEncoding =
                    basicCoinTestInterface.encodeFunctionData('register', [
                        user2,
                    ]);
                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    registerEncoding,
                    { from: user2 }
                );
                await this.basicCoin.protectionLayer(
                    this.basicCoinTest.address,
                    withdrawDepositEncoding,
                    { from: user1 }
                );
                expect(
                    await this.basicCoin.getBalance(user1)
                ).to.be.bignumber.equal('5');
                expect(
                    await this.basicCoin.getBalance(user2)
                ).to.be.bignumber.equal('5');
            });
        });
    });
    describe('when protection layer is not invoked', function () {
        it('register function should not work as expected ', async function () {
            await this.basicCoin.register({ from: user1 });
            await expectRevert(
                this.basicCoin.getBalance(user1),
                '0xffffffffffffffff'
            );
        });
        xit('should not allow to call register without protection layer', async function () {
            await expectRevert(
                this.basicCoin.register({ from: user1 }),
                'Only protection layer'
            );
        });
    });
});
