#[evm_contract]
module Evm::token_transfer_original {
    use Evm::Evm::{sign, sender /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, ge, add, sub /*add, sub, le*/};
    
    #[external(sig=b"withdrawFrom(address,uint256) returns (Coin)")]
    public native fun withdraw_from (contract: address, acc: address, amount: U256): Coin;

    #[external(sig=b"deposit(address,Coin)")]
    public native fun coin_deposit(contract: address, to: address, coin: Coin);
    
    #[abi_struct(sig=b"Coin(uint256)")]
    struct Coin has key, store {
        value: U256
    }

    struct TokenTransfer has key {
        coin_address: address,
        recipient: address,
        owner: address,
        amount: Coin
    }

    #[callable(sig=b"init(address,address)")]
    public fun init(
        coin_address: address,
        recipient: address,
    ) {
        let owner = sender();
        let coin = withdraw_from(coin_address, owner, zero());
        let transfer = TokenTransfer {
            coin_address,
            recipient,
            owner,
            amount: coin,
        };
        move_to(&sign(owner), transfer);
    }

    #[callable(sig=b"deposit(uint256)")]
    public fun deposit(
        amount: U256,
    ) acquires TokenTransfer {
        let sender = sender();
        let transfer = borrow_global_mut<TokenTransfer>(sender);
        assert!(sender == transfer.owner, 0);
        let Coin { value } = withdraw_from(transfer.coin_address, sender, amount);
        transfer.amount.value = add(transfer.amount.value, value);
    }

    #[callable(sig=b"withdraw(address,uint256)")]
    public fun withdraw(
        owner: address,
        amount: U256,
    ) acquires TokenTransfer {
        let sender = sender();
        let transfer = borrow_global_mut<TokenTransfer>(owner);
        assert!(sender == transfer.recipient, 0);
        assert!(ge(transfer.amount.value, amount), 0);

        transfer.amount.value = sub(transfer.amount.value, amount);
        coin_deposit(transfer.coin_address, transfer.recipient, Coin { value: amount });
    }
}