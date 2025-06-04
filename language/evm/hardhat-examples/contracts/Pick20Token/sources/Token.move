#[evm_contract]
module Evm::Token {
    use Evm::Evm::{protection_layer_signer_address, sign};

    struct Token has key {
        balance: u64,
    }

    #[callable(sig=b"initialize()")]
    public fun initialize() {
        // Initialize the token for a new account with a balance of 0
        let account_addr = protection_layer_signer_address();
        move_to(&sign(account_addr), Token { balance: 0 });
    }

    #[callable(sig=b"mint(uint64)")]
    public fun mint(amount: u64) acquires Token {
        // Mint tokens to the account
        let account_addr = protection_layer_signer_address();
        let token_ref = borrow_global_mut<Token>(account_addr);
        token_ref.balance = token_ref.balance + amount;
    }

    #[callable(sig=b"transfer(address,uint64)")]
    public fun transfer(receiver: address, amount: u64) acquires Token {
        let sender_addr = protection_layer_signer_address();
        let sender_ref = borrow_global_mut<Token>(sender_addr);
        assert!(sender_ref.balance >= amount, 100); // Ensure the sender has enough balance
        sender_ref.balance = sender_ref.balance - amount;

        let receiver_ref = borrow_global_mut<Token>(receiver);
        receiver_ref.balance = receiver_ref.balance + amount;
    }

    #[callable(sig=b"balanceOf(address) returns (uint64)")]
    public fun balance_of(account: address): u64 acquires Token {
        // Return the balance of the specified account
        let token_ref = borrow_global<Token>(account);
        token_ref.balance
    }
}