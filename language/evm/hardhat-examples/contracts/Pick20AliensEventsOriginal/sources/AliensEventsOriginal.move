#[evm_contract]
module Evm::aliens_events {
    use Evm::U256::{U256 /*gt, add, sub, zero, le*/};

    #[abi_struct(sig=b"WithdrawEvent(address,uint256,uint256)")]
    struct WithdrawEvent has store, drop {
        to: address,
        amount: U256,
        time: U256,
    }

    #[abi_struct(sig=b"SetReferrerEvent(string,address,uint256)")]
    struct SetReferrerEvent has store, drop {
        referrer: vector<u8>,
        account: address,
        time: U256,
    }

    #[abi_struct(sig=b"SetMintPriceEvent(uint256,uint256)")]
    struct SetMintPriceEvent has store, drop {
        mint_price: U256,
        time: U256,
    }

    #[callable(sig=b"newWithdrawEvent(address,uint256,uint256) returns (WithdrawEvent)")]
    public fun new_withdraw_event(
        to: address,
        amount: U256,
        time: U256
    ): WithdrawEvent {
        WithdrawEvent {
            to,
            amount,
            time,
        }
    }

    #[callable(sig=b"newSetReferrerEvent(string,address,uint256) returns (SetReferrerEvent)")]
    public fun new_set_referrer_event(
        referrer: vector<u8>,
        account: address,
        time: U256
    ): SetReferrerEvent {
        SetReferrerEvent {
            referrer,
            account,
            time,
        }
    }

    #[callable(sig=b"newSetMintPriceEvent(uint256,uint256) returns (SetMintPriceEvent)")]
    public fun new_set_mint_price_event(
        mint_price: U256,
        time: U256
    ): SetMintPriceEvent {
        SetMintPriceEvent {
            mint_price,
            time,
        }
    }
}