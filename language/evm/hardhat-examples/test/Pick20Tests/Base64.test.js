const { BN, constants, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Base64 = artifacts.require('Base64');

contract('Base64', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.base64 = await Base64.new({ from: deployer });
    });

    describe('Base64', function () {
        it('should call encode', async function () {
            let result = await this.base64.encode('Hello World', {
                from: user1,
            });
            console.log('Base64 encode cost: ', result.receipt.gasUsed);
        });
        it('should call decode', async function () {
            let result = await this.base64.decode('SGVsbG8gV29ybGQ=', {
                from: user1,
            });
            console.log('Base64 decode cost: ', result.receipt.gasUsed);
        });
    });
});
