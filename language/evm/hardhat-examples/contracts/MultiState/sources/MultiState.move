#[evm_contract]
module Evm::MultiState {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero};
    
    struct State has key {
        val: U256,
    }

    struct B has key {
        foo: U256,
    }

    #[create(sig=b"constructor(uint256,address)")]
    public fun create(val: U256, addr: address){
        let state = State {
            val
        };
        let b = B {
            foo: zero()
        };
        move_to<State>(&sign(addr), state);
        move_to<B>(&sign(addr), b);
    }

    #[callable(sig=b"setState(uint256,address)")]
    public fun setState(val: U256, addr: address) acquires State {
        let s = borrow_global_mut<State>(addr);
        s.val = val;
    }

    #[callable(sig=b"setB(uint256,address)")]
    public fun setB(foo: U256, addr: address) acquires B {
        let b = borrow_global_mut<B>(addr);
        b.foo = foo;
    }
    
    #[callable(sig=b"get(address) returns (uint256)"), view]
    public fun get(addr: address): U256 acquires State {
        let s = borrow_global<State>(addr);
        s.val
    }

    #[callable(sig=b"removeState(address)"), view]
    public fun removeState(addr: address) acquires State {
        let s = move_from<State>(addr);
        let State{ val: _ } = s;
    }

    #[callable(sig=b"removeB(address)"), view]
    public fun removeB(addr: address) acquires B {
        let b = move_from<B>(addr);
        let B{ foo: _ } = b;
    }
}