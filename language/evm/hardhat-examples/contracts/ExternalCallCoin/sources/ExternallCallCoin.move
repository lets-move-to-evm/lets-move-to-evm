#[evm_contract]
module Evm::external_call_coin {
    use Evm::Evm::{sign, self, sender, address_of, emit /*require address_of,*/};
    use Evm::U256::{U256/*, add, sub, zero, le*/};
    // use Evm::basicCoin::{Coin};


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
        coinId: U256,
    }

    #[event]
    struct SimpleEvent {
        x: U256,
    }

    #[callable(sig=b"start(address,address,uint256)")]
    public fun start(acc: address, coin_address: address, base: U256) /*acquires Bid*/ {
        let state = State {
            coin_address: coin_address,
            coin_owner: acc,
        };
        move_to(&sign(self()), state);
        
        let coin = withdraw(coin_address, base);
        move_to(&sign(acc), Bid { coinId: coin });
        store_external(coin_address, coin);
        // let bid = borrow_global_mut<Bid>(acc);
        // emit(SimpleEvent{ x: bid.coinId } );
    }

    #[callable(sig=b"bid(address,uint256)")]
    public fun bid(acc: address, amount: U256) acquires State, Bid {
        let state = borrow_global_mut<State>(self());
        let Bid { coinId } = move_from(state.coin_owner);
        // emit(SimpleEvent{ x: coinId } );
        unstore_external(state.coin_address, coinId);
        deposit(state.coin_address, state.coin_owner, coinId);
        let coin = withdraw(state.coin_address, amount);
        store_external(state.coin_address, coin);
        state.coin_owner = acc;
        move_to(&sign(acc), Bid { coinId: coin });
    }
}