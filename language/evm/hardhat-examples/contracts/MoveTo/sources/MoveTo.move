#[evm_contract]
module Evm::MoveTo {
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

    #[callable(sig=b"write(uint256)")]
    public fun write(val: U256) {
        let simple = Simple {
            foo: val
        };
        move_to<Simple>(&sign(sender()), simple);
    }
}