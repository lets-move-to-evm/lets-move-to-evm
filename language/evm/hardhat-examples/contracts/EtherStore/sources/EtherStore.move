#[evm_contract]
module Evm::EtherStore {
    /*
    use Evm::Evm::{self, sender, value, transfer};
    use Evm::Table::{Self, Table};
    use Evm::U256::{Self, U256};

    struct State has key {
        balances: Table<address, U256>,
    }

    #[callable(sig=b"deposit()"), payable]
    public fun deposit() acquires State {
        let s = borrow_global_mut<State>(self());
        let balance = mut_balanceOf(s, sender());
        *balance = U256::add(*balance, value());
    }

    
    #[callable(sig=b"withdraw()")]
    public fun withdraw() acquires State {
        let s = borrow_global_mut<State>(self());
        let balance = mut_balanceOf(s, sender());
        transfer(sender(), *balance);
        *balance = U256::zero();
    }
    

    /// Helper function to return a mut ref to the balance of a owner.
    fun mut_balanceOf(s: &mut State, owner: address): &mut U256 {
        Table::borrow_mut_with_default(&mut s.balances, &owner, U256::zero())
    }
    */

}