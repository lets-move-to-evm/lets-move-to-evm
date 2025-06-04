#[evm_contract]
module Evm::req_lev {
    use Evm::Evm::{sender, sign};

    struct PerpMarket has key {
        name: vector<u8>,
        base_token: vector<u8>,
        quote_token: vector<u8>,
        base_token_decimals: u8,
        quote_token_decimals: u8,
        min_base_token_amount: u64,
        min_quote_token_amount: u64,
        max_base_token_amount: u64,
        max_quote_token_amount: u64,
    }

    #[callable(sig=b"createPerpMarket(string,string,string,uint8,uint8,uint64,uint64,uint64,uint64)")]
    public entry fun create_perp_market(
        name: vector<u8>,
        base_token: vector<u8>,
        quote_token: vector<u8>,
        base_token_decimals: u8,
        quote_token_decimals: u8,
        min_base_token_amount: u64,
        min_quote_token_amount: u64,
        max_base_token_amount: u64,
        max_quote_token_amount: u64,
    ) {
        let account_addr = sender();
        assert!(!exists<PerpMarket>(account_addr), 0);
        move_to(&sign(account_addr), PerpMarket {
            name,
            base_token,
            quote_token,
            base_token_decimals,
            quote_token_decimals,
            min_base_token_amount,
            min_quote_token_amount,
            max_base_token_amount,
            max_quote_token_amount,
        });
    }
}
