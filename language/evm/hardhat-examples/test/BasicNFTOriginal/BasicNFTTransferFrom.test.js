const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers, Contract } = require('ethers');
const { ZERO_ADDRESS } = constants;

const BasicNFT = artifacts.require('BasicNFTOriginal');

contract('BasicNFT', function (accounts) {
    const [deployer, user1, user2] = accounts;

    beforeEach(async function () {
        this.basicNFT = await BasicNFT.new({ from: deployer });

        let result = await this.basicNFT.initToken(
            'BasicNFT',
            'https://basicnft.com/',
            {
                from: deployer,
            }
        );
        console.log('InitToken cost: ', result.receipt.gasUsed);

        result = await this.basicNFT.register({ from: user1 });
        console.log('Register cost: ', result.receipt.gasUsed);

        result = await this.basicNFT.register({ from: user2 });
        console.log('Register cost: ', result.receipt.gasUsed);

        expect(await this.basicNFT.balanceOf(deployer)).to.be.bignumber.equal(
            '1'
        );
        expect(await this.basicNFT.balanceOf(user1)).to.be.bignumber.equal('0');
        expect(await this.basicNFT.balanceOf(user2)).to.be.bignumber.equal('0');

        result = await this.basicNFT.mint(2, deployer, {
            from: deployer,
        });

        console.log('Mint cost: ', result.receipt.gasUsed);

        expect(await this.basicNFT.balanceOf(deployer)).to.be.bignumber.equal(
            '2'
        );

        result = await this.basicNFT.approve(user1, 2, {
            from: deployer,
        });

        console.log('Approve cost: ', result.receipt.gasUsed);
    });

    describe('when everything is set up', function () {
        it('should allow to transferFrom', async function () {
            let result = await this.basicNFT.transferFrom(deployer, user2, 2, {
                from: user1,
            });

            console.log('TransferFrom cost: ', result.receipt.gasUsed);
        });
    });
});
