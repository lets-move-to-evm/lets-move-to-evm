#[evm_contract]
module Evm::simple_wallet {
    use Evm::Evm::{sign, emit /*sender, address_of, require address_of,*/};
    use Evm::U256::{U256, le, zero /*gt, add, sub, zero, le*/};
    use std::vector;

    #[external(sig=b"withdraw(uint256) returns (uint256)")]
    public native fun withdraw_coin (contract: address, amount: U256): U256;

    #[external(sig=b"unstoreExternal(uint256)")]
    public native fun unstore_external(contract: address, coin: U256);

    #[external(sig=b"deposit(address,uint256)")]
    public native fun deposit_coin(contract: address, to: address, coin: U256);

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

    struct Wallet has key {
        coin_address: address,
        owner: address,
        transactions: vector<Transaction>,
        coins: CoinId
    }

    struct Transaction has store {
        coin_address: address,
        to: address,
        value: U256,
        data: vector<u8>,
        executed: bool
    }

    #[event(sig=b"Deposit(address,uint256,uint256)")]
    struct Deposit {
        sender: address,
        amount: U256,
        balance: U256
    }

    #[event(sig=b"Withdraw(address,uint256)")]
    struct Withdraw {
        sender: address,
        amount: U256
    }

    #[event(sig=b"SubmitTransaction(address,uint64,address,uint256,string)")]
    struct SubmitTransaction {
        owner: address,
        tx_id: u64,
        to: address,
        value: U256,
        data: vector<u8>
    }

    #[event(sig=b"ExecuteTransaction(address,uint64)")]
    struct ExecuteTransaction {
        owner: address,
        tx_id: u64
    }

    struct CoinId has store {
        id: U256,
    }

    #[callable(sig=b"initialize(address,address)")]
    public fun initialize(
        owner: address,
        coin_address: address
    ) {
        assert!(owner == get_signer(coin_address), 0);
        let coin = withdraw_coin(coin_address, zero());
        store_external(coin_address, coin);
        let wallet = Wallet {
            coin_address: coin_address,
            owner: owner,
            transactions: vector::empty<Transaction>(),
            coins: CoinId { id: coin }
        };
        move_to(&sign(owner), wallet);
    }

    #[callable(sig=b"deposit(address,address,uint256)")]
    public fun deposit(
        sender: address,
        wallet_owner: address,
        amount: U256
    ) acquires Wallet {
        let wallet = borrow_global_mut<Wallet>(wallet_owner);
        assert!(sender == get_signer(wallet.coin_address), 0);
        let coins = withdraw_coin(wallet.coin_address, amount);
        merge(wallet.coin_address, wallet.coins.id, coins);
        let deposit = Deposit {
            sender: sender,
            amount: amount,
            balance: coin_value(wallet.coin_address, wallet.coins.id)
        };
        emit(deposit);
    }

    #[callable(sig=b"withdraw(address)")]
    public fun withdraw(
        owner: address
    ) acquires Wallet {
        let wallet = borrow_global_mut<Wallet>(owner);
        assert!(owner == get_signer(wallet.coin_address), 0);
        assert!(owner == wallet.owner, 0);
        
        let withdraw = Withdraw {
            sender: owner,
            amount: coin_value(wallet.coin_address, wallet.coins.id)
        }; 

        let coin = extract(
            wallet.coin_address,
            wallet.coins.id,
            withdraw.amount
        );
        deposit_coin(wallet.coin_address, wallet.owner, coin);

        emit(withdraw);
    }

    #[callable(sig=b"createTransaction(address,address,uint256,string) returns (uint64)")]
    public fun create_transaction(
        owner: address,
        to: address,
        value: U256,
        data: vector<u8>
    ): u64 acquires Wallet {
        let wallet = borrow_global_mut<Wallet>(owner);
        assert!(owner == get_signer(wallet.coin_address), 0);
        assert!(owner == wallet.owner, 0);

        let tx_id = vector::length(&wallet.transactions);

        let transaction = Transaction {
            coin_address: wallet.coin_address,
            to: to,
            value: value,
            data: data,
            executed: false
        };

        vector::push_back(&mut wallet.transactions, transaction);

        let submit_transaction = SubmitTransaction {
            owner: owner,
            tx_id: tx_id,
            to: to,
            value: value,
            data: data
        };
        emit(submit_transaction);
        tx_id
    }

    #[callable(sig=b"executeTransaction(address,uint64)")]
    public fun execute_transaction(
        owner: address,
        tx_id: u64
    ) acquires Wallet {
        let wallet = borrow_global_mut<Wallet>(owner);
        assert!(owner == get_signer(wallet.coin_address), 4);
        assert!(owner == wallet.owner, 1);

        let transaction = vector::borrow_mut(&mut wallet.transactions, tx_id);
        
        assert!(transaction.executed == false, 2);
        assert!(le(transaction.value, coin_value(wallet.coin_address, wallet.coins.id)), 3);
        transaction.executed = true;
        let coins = extract(
            wallet.coin_address,
            wallet.coins.id,
            transaction.value
        );
        deposit_coin(
            wallet.coin_address,
            transaction.to,
            coins
        );
        let execute_transaction = ExecuteTransaction {
            owner: owner,
            tx_id: tx_id
        };
        emit(execute_transaction);
    }
}