#[evm_contract]
module Evm::Payable {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero};
    
    struct State has key {
        deposited: U256
    }

    #[create(sig=b"constructor()")]
    public fun create() {
        let state = State {
            deposited: zero()
        };
        move_to<State>(&sign(self()), state);
    }

    #[callable(sig=b"deposit()"), payable]
    public fun deposit() acquires State {
        let s = borrow_global_mut<State>(self());
        s.deposited = U256::add(s.deposited, value());
    }
    
    #[callable(sig=b"deposited() returns (uint256)"), view]
    public fun deposited(): U256 acquires State {
        let s = borrow_global<State>(self());
        s.deposited
    }
}