#[evm_contract]
module Evm::protection_layer_costs {
    use Evm::Evm::{sender, sign, require, /*address_of,*/};
    use Evm::U256::{U256, zero};// , add, sub, u256_from_u128, le};

    #[abi_struct(sig=b"S(uint256)")]
    struct S has key {
        val: U256
    }
    
    #[callable(sig=b"write(uint256)")]
    public fun write(val: U256) {
        let account_addr = sender();
        let s = S { val: val };
        move_to(&sign(account_addr), s);
    }

    #[callable(sig=b"read() returns (uint256)"), view]
    public fun read(): U256 acquires S {
        let account_addr = sender();
        let s = borrow_global<S>(account_addr);
        s.val
    }

    // edit with borrow_global
    #[callable(sig=b"edit(uint256,address)")]
    public fun edit(val: U256, acc: address) acquires S {
        let s = borrow_global_mut<S>(acc);
        s.val = val;
    }

    // get function
    #[callable(sig=b"get() returns (S)"), view]
    public fun get(): S {
        let s = S { val: zero() };
        s
    }

    // put function
    #[callable(sig=b"put(S)")]
    public fun put(s: S) {
        move_to(&sign(sender()), s);
    }

    // remove
    #[callable(sig=b"remove() returns (S)")]
    public fun remove(): S acquires S{
        let account_addr = sender();
        move_from<S>(account_addr)
    }

    // sink function
    #[callable(sig=b"sink(S)")]
    public fun sink(s: S) {
        let S { val } = s;
    }

    // #[callable(sig=b"readRef(uint256) returns (uint256)"), view]
    // public fun read_ref(ref: &S): U256 {
    //     ref.val
    // }

    // #[callable(sig=b"writeRef(uint256,uint256)")]
    // public fun write_ref(ref: &mut S, val: U256) {
    //     ref.val = val;
    // }

    #[callable(sig=b"doNothing()", view)]
    public fun do_nothing() {}
}