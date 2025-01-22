#[evm_contract]
module Evm::ReentrantContract {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero, u256_from_u128};

    struct State has key {
        val: U256
    }

    #[create(sig=b"constructor()")]
    public fun create(){
        let state = State {
            val: zero()
        };
        move_to<State>(&sign(self()), state);   
    }

    #[external(sig=b"attack()")]
    public native fun call_external_reentrant(destination: address);

    #[callable(sig=b"start_attack(address)")]
    public fun start_attack(destination: address) {
        call_external_reentrant(destination);
    }

    #[callable(sig=b"reentrant_function()")]
    public fun reentrant_function() acquires State{
        let s = borrow_global_mut<State>(self());
        s.val = u256_from_u128(44);
    }

    #[callable(sig=b"get() returns (uint256)"), view]
    public fun get(): U256 acquires State {
        let s = borrow_global<State>(self());
        s.val
    }

    #[callable(sig=b"set(uint256)")]
    public fun set(val: U256) acquires State {
        let s = borrow_global_mut<State>(self());
        s.val = val;
    }
}