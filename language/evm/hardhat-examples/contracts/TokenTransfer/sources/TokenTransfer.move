#[evm_contract]
module Evm::token_transfer {
    use Evm::Evm::{sign /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, ge /*add, sub, le*/};

    #[external(sig=b"withdraw(uint256) returns (uint256)")]
    public native fun coin_withdraw (contract: address, amount: U256): U256;

    #[external(sig=b"unstoreExternal(uint256)")]
    public native fun unstore_external(contract: address, coin: U256);

    #[external(sig=b"deposit(address,uint256)")]
    public native fun coin_deposit(contract: address, to: address, coin: U256);

    #[external(sig=b"storeExternal(uint256)")]
    public native fun store_external(contract: address, coin: U256);

    #[external(sig=b"coinValue(uint256) returns (uint256)")]
    public native fun coin_value(contract: address, coin: U256): U256;

    #[external(sig=b"merge(uint256,uint256)")]
    public native fun merge(contract: address, coin1: U256, coin2: U256);

    #[external(sig=b"extract(uint256,uint256) returns (uint256)")]
    public native fun extract(contract: address, coin: U256, amount: U256): U256;

    #[external(sig=b"getSigner() returns (address)")]
    public native fun get_signer(contract: address): address;

    struct CoinId has store {
        id: U256,
    }

    struct TokenTransfer has key {
        coin_address: address,
        recipient: address,
        owner: address,
        amount: CoinId
    }

    #[callable(sig=b"init(address,address,address)")]
    public fun init(
        coin_address: address,
        owner: address,
        recipient: address,
    ) {
        assert!(owner == get_signer(coin_address), 0);
        let coin = coin_withdraw(coin_address, zero());
        store_external(coin_address, coin);
        let transfer = TokenTransfer {
            coin_address,
            recipient,
            owner,
            amount: CoinId { id: coin },
        };
        move_to(&sign(owner), transfer);
    }

    #[callable(sig=b"deposit(address,uint256)")]
    public fun deposit(
        sender: address,
        amount: U256,
    ) acquires TokenTransfer {
        let transfer = borrow_global<TokenTransfer>(sender);
        assert!(sender == get_signer(transfer.coin_address), 0);
        assert!(sender == transfer.owner, 0);
        let coins = coin_withdraw(transfer.coin_address, amount);
        merge(transfer.coin_address, transfer.amount.id, coins);
    }

    #[callable(sig=b"withdraw(address,address,uint256)")]
    public fun withdraw(
        sender: address,
        owner: address,
        amount: U256,
    ) acquires TokenTransfer {
        let transfer = borrow_global<TokenTransfer>(owner);
        assert!(sender == get_signer(transfer.coin_address), 0);
        assert!(sender == transfer.recipient, 0);
        assert!(ge(coin_value(transfer.coin_address, transfer.amount.id), amount), 0);

        let withdraw = extract(transfer.coin_address, transfer.amount.id, amount);
        coin_deposit(transfer.coin_address, transfer.recipient, withdraw);
    }
        
}