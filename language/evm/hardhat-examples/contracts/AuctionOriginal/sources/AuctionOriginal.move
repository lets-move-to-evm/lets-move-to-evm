#[evm_contract]
module Evm::auction_original {
    use Evm::Evm::{sign, self, sender, /*address_of, require address_of,*/};
    use Evm::U256::{U256, gt/*, add, sub, zero, le*/};

    #[abi_struct(sig=b"Coin(uint256)")]
    struct Coin has key, store {
        value: U256
    }

    #[external(sig=b"withdrawFrom(address,uint256) returns (Coin)")]
    public native fun withdraw_from (contract: address, acc: address, amount: U256): Coin;

    #[external(sig=b"deposit(address,Coin)")]
    public native fun deposit(contract: address, to: address, coin: Coin);

    struct Auction has key {
        coin_address: address,
        auctioneer: address,
        top_bidder: address,
        expired: bool
    }

    struct Bid has key {
        coin: Coin,
    }

    #[callable(sig=b"start(address,uint256)")]
    public fun start(coin_address: address, base: U256) {
        let acc = sender();
        let state = Auction {
            coin_address: coin_address,
            auctioneer: acc,
            top_bidder: acc,
            expired: false
        };
        move_to(&sign(self()), state);
        
        let coin = withdraw_from(coin_address, acc, base);
        move_to(&sign(acc), Bid { coin });
    }

    #[callable(sig=b"bid(uint256)")]
    public fun bid(amount: U256) acquires Auction, Bid {
        let acc = sender();
        let auction = borrow_global_mut<Auction>(self());
        let Bid { coin } = move_from<Bid>(auction.top_bidder);
        assert!(!auction.expired, 0);
        assert!(gt(amount, coin.value), 0);
        deposit(auction.coin_address, auction.top_bidder, coin);
        let coin = withdraw_from(auction.coin_address, acc, amount);
        auction.top_bidder = acc;
        move_to(&sign(acc), Bid { coin });
    }

    #[callable(sig=b"end()")]
    public fun end() acquires Auction, Bid {
        let acc = sender();
        let auction = borrow_global_mut<Auction>(self());
        assert!(auction.auctioneer == acc, 0);
        assert!(!auction.expired, 0);
        auction.expired = true;
        let Bid { coin } = move_from<Bid>(auction.top_bidder);
        deposit(auction.coin_address, auction.auctioneer, coin);
    }
}