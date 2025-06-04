#[evm_contract]
module Evm::vector_generic {
    use std::vector;
    use Evm::Evm::{sign, sender};

    struct State has key {
        v: vector<S>
    }

    struct S has store {
        a: u64,
        b: bool
    }

    #[callable(sig=b"vectorGeneric()")]
    public fun vector_generic() {
        let v = vector::empty<S>();
        vector::push_back(&mut v, S { a: 0, b: true });
        move_to(&sign(sender()), State { v });
    }
}