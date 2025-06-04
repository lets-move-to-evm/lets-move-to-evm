#[evm_contract]
module Evm::auction {
    use Evm::Evm::{sign, self /*require address_of,*/};
    use Evm::U256::{U256, gt/*, add, sub, zero, le*/};

    #[external(sig=b"withdraw(uint256) returns (uint256)")]
    public native fun withdraw (contract: address, amount: U256): U256;

    #[external(sig=b"unstoreExternal(uint256)")]
    public native fun unstore_external(contract: address, coin: U256);

    #[external(sig=b"deposit(address,uint256)")]
    public native fun deposit(contract: address, to: address, coin: U256);

    #[external(sig=b"storeExternal(uint256)")]
    public native fun store_external(contract: address, coin: U256);

    #[external(sig=b"coinValue(uint256) returns (uint256)")]
    public native fun coin_value(contract: address, coin: U256): U256;

    #[external(sig=b"getSigner() returns (address)")]
    public native fun get_signer(contract: address): address;

    struct Auction has key {
        coin_address: address,
        auctioneer: address,
        top_bidder: address,
        expired: bool
    }

    struct Bid has key {
        coinId: U256,
    }

    #[callable(sig=b"start(address,address,uint256)")]
    public fun start(acc: address, coin_address: address, base: U256) {
        assert!(acc == get_signer(coin_address), 0);
        let state = Auction {
            coin_address: coin_address,
            auctioneer: acc,
            top_bidder: acc,
            expired: false
        };
        move_to(&sign(self()), state);
        
        let coin = withdraw(coin_address, base);
        move_to(&sign(acc), Bid { coinId: coin });
        store_external(coin_address, coin);
    }

    #[callable(sig=b"bid(address,uint256)")]
    public fun bid(acc: address, amount: U256) acquires Auction, Bid {
        let auction = borrow_global_mut<Auction>(self());
        assert!(acc == get_signer(auction.coin_address), 0);
        let Bid { coinId } = move_from<Bid>(auction.top_bidder);
        assert!(!auction.expired, 0);
        assert!(gt(amount, coin_value(auction.coin_address, coinId)), 0);
        unstore_external(auction.coin_address, coinId);
        deposit(auction.coin_address, auction.top_bidder, coinId);
        let coin = withdraw(auction.coin_address, amount);
        auction.top_bidder = acc;
        store_external(auction.coin_address, coin);
        move_to(&sign(acc), Bid { coinId: coin });
    }

    #[callable(sig=b"end(address)")]
    public fun end(acc: address) acquires Auction, Bid {
        let auction = borrow_global_mut<Auction>(self());
        assert!(acc == get_signer(auction.coin_address), 0);
        assert!(auction.auctioneer == acc, 0);
        assert!(!auction.expired, 0);
        auction.expired = true;
        let Bid { coinId } = move_from<Bid>(auction.top_bidder);
        unstore_external(auction.coin_address, coinId);
        deposit(auction.coin_address, auction.auctioneer, coinId);
    }
}