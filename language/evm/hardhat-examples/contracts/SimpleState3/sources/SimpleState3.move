#[evm_contract]
module Evm::SimpleState3 {
    use Evm::Evm::{sign, sender};
    use Evm::U256::{U256, zero, u256_from_u128};
    
    struct S has key {
        val: U256,
    }

    #[create(sig=b"constructor()")]
    public fun create() {
        move_to(&sign(sender()), S { val: zero() });
    }

    #[callable(sig=b"set(uint256)")]
    public fun set(val: U256) {
        move_to(&sign(sender()), S {val});
    }

    #[callable(sig=b"get() returns (uint256)"), view]
    public fun get(): U256 acquires S {
        let state = borrow_global<S>(sender());
        state.val
    }

    #[callable(sig=b"initialize()")]
    public fun initialize() {
        move_to(&sign(sender()), S { val: u256_from_u128(44) });
    }

    #[callable(sig=b"edit(uint256)")]
    public fun edit(val: U256) acquires S {
        let state = borrow_global_mut<S>(sender());
        state.val = val;
    }

    #[callable(sig=b"remove()")]
    public fun remove() acquires S {
        let state = move_from<S>(sender());
        let S{ val: _ } = state;
    }
}