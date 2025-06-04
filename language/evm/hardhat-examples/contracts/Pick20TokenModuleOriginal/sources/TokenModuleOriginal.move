#[evm_contract]
module Evm::token_module_original {
    use Evm::Evm::{sender, sign};

    struct Balance has key {
        amount: u64,
    }

    #[callable(sig=b"initializeBalance(uint64)")]
    public fun initialize_balance(initial_amount: u64) {
        let account = sender();
        let bal = Balance { amount: initial_amount };
        move_to(&sign(account), bal);
    }

    #[callable(sig=b"initializeBalance()")]
    public fun initialize_token_store() {
        initialize_balance(0)  // Initialize with 0 tokens by default
    }

    #[callable(sig=b"transfer(address,uint64)")]
    public fun transfer(recipient: address, amount: u64) acquires Balance {
        let admin_address = sender();
        assert!(amount > 0, 1001);

        assert!(admin_address != recipient, 1003);

        let admin_balance = borrow_global_mut<Balance>(admin_address);
        assert!(admin_balance.amount >= amount, 1002);
        admin_balance.amount = admin_balance.amount - amount;

        let recipient_balance = borrow_global_mut<Balance>(recipient);
        recipient_balance.amount = recipient_balance.amount + amount;
    }

    #[callable(sig=b"getBalance(address) returns (uint64)")]
    public fun get_balance(account: address): u64 acquires Balance {
        let bal = borrow_global<Balance>(account);
        bal.amount
    }
} 