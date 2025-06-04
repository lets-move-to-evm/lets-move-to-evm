#[evm_contract]
module Evm::AuctionEvmLike {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero};
    
    struct State has key {
        beneficiary: address,
        auction_end: U256,
        highest_bidder: address,
        highest_bid: U256,
        ended: bool
    }

    #[create(sig=b"constructor(address,uint256)")]
    public fun create(beneficiary: address, bidding_time: U256) {
        let state = State {
            beneficiary: beneficiary,
            auction_end: U256::add(bidding_time, block_number()),
            highest_bidder: sender(),
            highest_bid: zero(),
            ended: false
        };
        move_to<State>(&sign(self()), state);
    }

    #[callable(sig=b"bid()"), payable]
    public fun bid() acquires State {
        let s = borrow_global_mut<State>(self());
        assert!(U256::gt(value(), s.highest_bid), 0);
        s.highest_bidder = sender();
        s.highest_bid = value();
    }
}