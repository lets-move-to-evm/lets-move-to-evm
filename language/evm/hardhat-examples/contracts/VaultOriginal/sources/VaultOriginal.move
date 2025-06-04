#[evm_contract]
module Evm::vault_original {
    use Evm::Evm::{sign, block_timestamp, sender /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, ge, add, sub /*add, sub, le*/};

    #[external(sig=b"withdrawFrom(address,uint256) returns (Coin)")]
    public native fun withdraw_from (contract: address, acc: address, amount: U256): Coin;

    #[external(sig=b"deposit(address,Coin)")]
    public native fun coin_deposit(contract: address, to: address, coin: Coin);
    
    #[external(sig=b"getExchangeRate() returns (uint256)")]
    public native fun get_exchange_rate(contract: address): U256;
    
    #[abi_struct(sig=b"Coin(uint256)")]
    struct Coin has key, store {
        value: U256
    }

    struct Vault has key {
        coin_address: address,
        owner: address,
        recovery: address,
        wait_time: U256,
        coins: Coin,
        state: u8,
        request_timestamp: U256,
        amount: U256,
        receiver: address
    }

    #[callable(sig=b"init(address,uint256,address)")]
    public fun init(
        recovery: address,
        wait_time: U256,
        coin_address: address,
    ) {
        let owner = sender();
        let coin = withdraw_from(coin_address, owner, zero());
        
        let vault = Vault {
            coin_address,
            owner,
            recovery,
            wait_time,
            coins: coin,
            state: 0,
            request_timestamp: zero(),
            amount: zero(),
            receiver: @0x0
        };
        move_to(&sign(owner), vault);
    }

    #[callable(sig=b"deposit(uint256)")]
    public fun deposit(
        amount: U256,
    ) acquires Vault {
        let owner = sender();
        let vault = borrow_global_mut<Vault>(owner);
        let Coin { value } = withdraw_from(vault.coin_address, owner, amount);
        vault.coins.value = add(vault.coins.value, value);
    }

    #[callable(sig=b"withdraw(uint256,address)")]
    public fun withdraw(
        amount: U256,
        receiver: address,
    ) acquires Vault {
        let owner = sender();
        let vault = borrow_global_mut<Vault>(owner);
        assert!(owner == vault.owner, 0);
        assert!(ge(vault.coins.value, amount), 0);
        assert!(vault.state == 0, 0);

        vault.request_timestamp = block_timestamp();
        vault.amount = amount;
        vault.state = 1;
        vault.receiver = receiver;
    }

    #[callable(sig=b"finalize()")]
    public fun finalize(
    ) acquires Vault {
        let owner = sender();
        let vault = borrow_global_mut<Vault>(owner);
        assert!(owner == vault.owner, 0);
        assert!(vault.state == 1, 0);
        assert!(ge(block_timestamp(), add(vault.request_timestamp, vault.wait_time)), 0);

        vault.state = 0;
        let amount = vault.amount;
        vault.amount = zero();
        vault.coins.value = sub(vault.coins.value, amount);    
        coin_deposit(vault.coin_address, vault.receiver, Coin { value: amount });
    }

    #[callable(sig=b"cancel(address)")]
    public fun cancel(
        recovery: address,
    ) acquires Vault {
        let owner = sender();
        let vault = borrow_global_mut<Vault>(owner);
        assert!(owner == vault.owner, 0);
        assert!(recovery == vault.recovery, 0);
        assert!(vault.state == 1, 0);

        vault.state = 0;
    }
}