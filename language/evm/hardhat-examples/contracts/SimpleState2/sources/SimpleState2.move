#[evm_contract]
module Evm::SimpleState2 {
    use Evm::Evm::{sign, self};
    use Evm::U256::U256;
    
    struct State has key {
        val: U256,
    }

    #[create(sig=b"constructor(uint256)")]
    public fun create(val: U256){
        let state = State {
            val
        };
        move_to<State>(&sign(self()), state);
    }

    #[callable(sig=b"set(uint256,address)")]
    public fun set(val: U256, addr: address) acquires State {
        let s = borrow_global_mut<State>(addr);
        s.val = val;
    }
    
    #[callable(sig=b"get(address) returns (uint256)"), view]
    public fun get(addr: address): U256 acquires State {
        let s = borrow_global<State>(addr);
        s.val
    }

    #[callable(sig=b"remove(address)"), view]
    public fun remove(addr: address) acquires State {
        let s = move_from<State>(addr);
        let State{ val: _ } = s;
    }
}