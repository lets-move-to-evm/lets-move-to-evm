#[evm_contract]
module Evm::SimpleState {
    use Evm::Evm::{sign, sender};
    use Evm::U256::{U256, zero};
    
    #[storage]
    struct State has key {
        val: U256,
    }

    #[create(sig=b"constructor(uint256)")]
    public fun create(val: U256): State {
        State {val}
    }

    #[callable(sig=b"set(uint256)")]
    public fun set(state: &mut State, val: U256) {
        state.val = val;
    }

    #[callable(sig=b"edit(uint256,address)")]
    public fun edit(val: U256, acc: address) acquires State {
        let state = borrow_global_mut<State>(acc);
        state.val = val;
    }
}