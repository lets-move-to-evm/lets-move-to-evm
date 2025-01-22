//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
}

interface IBasicCoin is IProtectionLayerV2 {
    function register() external;
    function transfer(address, uint256) external;
    function mint(uint256) external returns (uint256);
    function getBalance(address) external view returns (uint256);
    function withdraw(uint256) external returns (uint256);
    function deposit(address, uint256) external;
    function coinValue(uint256) external view returns (uint256);
}

contract Auction {
    struct Bid {
        address highestBidder;
        uint256 coin;
    }

    IBasicCoin public immutable basicCoin;

    Bid public highestBid;

    constructor(address _basicCoin) {
        basicCoin = IBasicCoin(_basicCoin);
    }

    function startAuction(address signer) public {
        uint coin = basicCoin.withdraw(1);
        basicCoin.storeExternal(coin);
        highestBid = Bid(signer, coin);
    }

    function bid(address signer, uint256 amount) public {
        uint256 balance = basicCoin.coinValue(highestBid.coin);
        require(amount > balance, 'Bid not high enough');
        if (amount > 0) {
            // send back old bid
            basicCoin.unstoreExternal(highestBid.coin);
            basicCoin.deposit(highestBid.highestBidder, highestBid.coin);
            // store new bid
            uint256 newBid = basicCoin.withdraw(amount);
            basicCoin.storeExternal(newBid);
            highestBid = Bid(signer, newBid);
        }
    }

    function bidEncoding(uint256 amount) public view returns (bytes memory) {
        return abi.encodeCall(this.bid, (msg.sender, amount));
    }

    function startAuctionEncoding() public view returns (bytes memory) {
        return abi.encodeCall(this.startAuction, (msg.sender));
    }
}
