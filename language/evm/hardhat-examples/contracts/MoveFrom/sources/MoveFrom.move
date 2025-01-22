#[evm_contract]
module Evm::MoveFrom {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero};
    
    struct State has key {
        val: U256,
    }

    struct Simple has key {
        foo: U256,
    }

    #[create(sig=b"constructor(uint256,address)")]
    public fun create(val: U256, addr: address){
        let state = State {
            val
        };
        move_to<State>(&sign(addr), state);
    }

    #[callable(sig=b"foo()")]
    public fun foo() acquires Simple {
        let s = getSimple();
        s.foo = zero();
        writeSimple(s);
    }

    public fun getSimple(): Simple acquires Simple {
        let s = move_from<Simple>(sender());
        return s
    }

    public fun writeSimple(s: Simple) {
        move_to<Simple>(&sign(sender()), s);

    }
}