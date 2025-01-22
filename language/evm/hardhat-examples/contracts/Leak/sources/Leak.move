#[evm_contract]
module Evm::Leak {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero};
    
    struct State has key {
        val: U256,
    }

    struct Simple {
        val: U256,
        foo: bool,
    }

    #[create(sig=b"constructor(uint256,address)")]
    public fun create(val: U256, addr: address){
        let state = State {
            val
        };
        move_to<State>(&sign(addr), state);
    }

    #[callable(sig=b"get() returns (uint256)"), view]
    public fun get(): U256 {
        let s = g();
        let val = s.val;
        f(s);
        val
    }

    public fun g(): Simple {
        Simple { val: zero(), foo: false }
    }

    public fun f(s: Simple) {
        let Simple{ val, foo } = s;
    }

    /*
    #[callable(sig=b"set(uint256,address)")]
    public fun set(val: U256, addr: address) acquires State {
        let s = borrow_global_mut<State>(addr);
        s.val = val;
    }
    

    #[callable(sig=b"remove(address)"), view]
    public fun remove(addr: address) acquires State {
        let s = move_from<State>(addr);
        let State{ val: _ } = s;
    }
    */

}