#[evm_contract]
module Evm::SelfState {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero};
    
    struct State has key {
        val: U256,
    }

    #[create(sig=b"constructor()")]
    public fun create(){
        let state = State {
            val: zero(),
        };
        move_to<State>(&sign(self()), state);
    }

    #[callable(sig=b"set(uint256)")]
    public fun set(val: U256) acquires State {
        let s = borrow_global_mut<State>(self());
        s.val = val;
    }
    
    #[callable(sig=b"get() returns (uint256)"), view]
    public fun get(): U256 acquires State {
        let s = borrow_global<State>(self());
        s.val
    }

    #[callable(sig=b"remove()"), view]
    public fun remove() acquires State {
        let s = move_from<State>(self());
        let State{ val: _ } = s;
    }
}