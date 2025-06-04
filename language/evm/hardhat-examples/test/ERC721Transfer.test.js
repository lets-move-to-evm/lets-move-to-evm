const {
    BN,
    constants,
    expectEvent,
    expectRevert,
} = require('@openzeppelin/test-helpers');

const ERC721Mock = artifacts.require('ERC721Mock'); // A Move contract

const firstTokenId = new BN('5042');
const secondTokenId = new BN('79217');

contract('ERC721', function (accounts) {
    const [owner, newOwner, approved, anotherApproved, operator, other] =
        accounts;
    const name = 'Non Fungible Token';
    const symbol = 'NFT';

    beforeEach(async function () {
        this.token = await ERC721Mock.new(name, symbol);
    });

    context('with minted tokens', function () {
        beforeEach(async function () {
            await this.token.mint(owner, firstTokenId);
            await this.token.mint(owner, secondTokenId);
            this.toWhom = other; // default to other for toWhom in context-dependent tests
        });

        it('transfers', async function () {
            const tokenId = firstTokenId;
            const data = '0x42';

            let logs = null;

            await this.token.approve(approved, tokenId, { from: owner });
            // await this.token.setApprovalForAll(operator, true, { from: owner });

            ({ logs } = await this.token.transferFrom(
                owner,
                this.toWhom,
                tokenId,
                { from: owner }
            ));

            expect(await this.token.ownerOf(tokenId)).to.be.equal(this.toWhom);
        });
    });
});
