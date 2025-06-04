#[evm_contract]
module Evm::vault {
    use Evm::Evm::{sign, block_timestamp /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, ge, add /*add, sub, le*/};

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

    struct Vault has key {
        coin_address: address,
        owner: address,
        recovery: address,
        wait_time: U256,
        coins: CoinId,
        state: u8,
        request_timestamp: U256,
        amount: U256,
        receiver: address
    }

    #[callable(sig=b"init(address,address,uint256,address)")]
    public fun init(
        owner: address,
        recovery: address,
        wait_time: U256,
        coin_address: address,
    ) {
        assert!(owner == get_signer(coin_address), 0);
        let coin = coin_withdraw(coin_address, zero());
        store_external(coin_address, coin);
        
        let vault = Vault {
            coin_address,
            owner,
            recovery,
            wait_time,
            coins: CoinId { id: coin },
            state: 0,
            request_timestamp: zero(),
            amount: zero(),
            receiver: @0x0
        };
        move_to(&sign(owner), vault);
    }

    #[callable(sig=b"deposit(address,uint256)")]
    public fun deposit(
        owner: address,
        amount: U256,
    ) acquires Vault {
        let vault = borrow_global<Vault>(owner);
        let coins = coin_withdraw(vault.coin_address, amount);
        merge(vault.coin_address, vault.coins.id, coins);
    }

    #[callable(sig=b"withdraw(address,uint256,address)")]
    public fun withdraw(
        owner: address,
        amount: U256,
        receiver: address,
    ) acquires Vault {
        let vault = borrow_global_mut<Vault>(owner);
        assert!(owner == get_signer(vault.coin_address), 0);
        assert!(owner == vault.owner, 0);
        assert!(ge(coin_value(vault.coin_address, vault.coins.id), amount), 0);
        assert!(vault.state == 0, 0);

        vault.request_timestamp = block_timestamp();
        vault.amount = amount;
        vault.state = 1;
        vault.receiver = receiver;
    }

    #[callable(sig=b"finalize(address)")]
    public fun finalize(
        owner: address,
    ) acquires Vault {
        let vault = borrow_global_mut<Vault>(owner);
        assert!(owner == get_signer(vault.coin_address), 0);
        assert!(owner == vault.owner, 0);
        assert!(vault.state == 1, 0);
        assert!(ge(block_timestamp(), add(vault.request_timestamp, vault.wait_time)), 0);

        vault.state = 0;
        let coins = extract(vault.coin_address, vault.coins.id, vault.amount);    
        coin_deposit(vault.coin_address, vault.receiver, coins);
    }

    #[callable(sig=b"cancel(address,address)")]
    public fun cancel(
        owner: address,
        recovery: address,
    ) acquires Vault {
        let vault = borrow_global_mut<Vault>(owner);
        assert!(owner == get_signer(vault.coin_address), 0);
        assert!(owner == vault.owner, 0);
        assert!(recovery == vault.recovery, 0);
        assert!(vault.state == 1, 0);

        vault.state = 0;
    }
}