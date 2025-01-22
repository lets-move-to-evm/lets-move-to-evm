const {
    BN,
    constants,
    expectEvent,
    expectRevert,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ZERO_ADDRESS } = constants;

const ERC20Mock = artifacts.require('ERC20Mock');

contract('ERC20', function (accounts) {
    const [initialHolder, recipient, anotherAccount] = accounts;

    const name = 'My Token';
    const symbol = 'MTKN';

    const initialSupply = new BN(100);

    beforeEach(async function () {
        this.token = await ERC20Mock.new(
            name,
            symbol,
            initialHolder,
            initialSupply
        );
    });

    describe('_transfer', function () {
        it('should transfer tokens', async function () {
            await this.token.transferInternal(
                initialHolder,
                recipient,
                initialSupply
            );
            expect(
                await this.token.balanceOf(initialHolder)
            ).to.be.bignumber.equal('0');

            expect(await this.token.balanceOf(recipient)).to.be.bignumber.equal(
                initialSupply
            );
        });
    });
});
