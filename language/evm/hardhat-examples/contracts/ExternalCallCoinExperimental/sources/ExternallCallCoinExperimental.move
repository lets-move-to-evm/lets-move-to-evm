#[evm_contract]
module Evm::external_call_coin_exp {
    use Evm::Evm::{sign, self, emit, address_of /* sender, require, address_of,*/};
    use Evm::U256::{U256/*, add, sub, zero, le*/};
    // use Evm::basicCoin::{Coin};

    // struct Coin has store {
    //     value: U256
    // }

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

    struct State has key {
        coin_address: address,
        coin_owner: address
    }

    struct Bid has key {
        coin: U256,
    }

    #[event]
    struct SimpleEvent {
        x: U256,
    }

    #[callable(sig=b"start(address,address,uint256)")]
    public fun start(acc: address, coin_address: address, base: U256) {
        let state = State {
            coin_address: coin_address,
            coin_owner: acc,
        };
        move_to(&sign(self()), state);
        
        let coin = withdraw(coin_address, base);
        let bid = Bid { coin: coin };
        move_to(&sign(acc), bid);
        store_external(coin_address, coin);
        emit(SimpleEvent{ x: coin } );
    }

    #[callable(sig=b"bid(address,uint256)")]
    public fun bid(acc: address, amount: U256) acquires State, Bid {
        let state = borrow_global_mut<State>(self());
        let Bid { coin } = move_from(state.coin_owner);
        emit(SimpleEvent{ x: coin } );
        unstore_external(state.coin_address, coin);
        deposit(state.coin_address, state.coin_owner, coin);
        state.coin_owner = acc;
        let coin = withdraw(state.coin_address, amount);
        store_external(state.coin_address, coin);
        move_to(&sign(acc), Bid { coin: coin });
    }
}