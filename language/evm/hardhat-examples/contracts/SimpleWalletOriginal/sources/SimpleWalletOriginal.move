#[evm_contract]
module Evm::simple_wallet_original {
    use Evm::Evm::{sign, emit, sender, /*sender, address_of, require address_of,*/};
    use Evm::U256::{U256, le, zero, add, sub /*gt, add, sub, zero, le*/};
    use std::vector;

    #[external(sig=b"withdrawFrom(address,uint256) returns (Coin)")]
    public native fun withdraw_from (contract: address, acc: address, amount: U256): Coin;

    #[external(sig=b"deposit(address,Coin)")]
    public native fun coin_deposit(contract: address, to: address, coin: Coin);

    #[abi_struct(sig=b"Coin(uint256)")]
    struct Coin has key, store {
        value: U256
    }

    struct Wallet has key {
        coin_address: address,
        owner: address,
        transactions: vector<Transaction>,
        coins: Coin
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

    #[callable(sig=b"initialize(address)")]
    public fun initialize(
        coin_address: address
    ) {
        let owner = sender();
        let coin = withdraw_from(coin_address, owner, zero());
        let wallet = Wallet {
            coin_address: coin_address,
            owner: owner,
            transactions: vector::empty<Transaction>(),
            coins: coin
        };
        move_to(&sign(owner), wallet);
    }

    #[callable(sig=b"deposit(address,uint256)")]
    public fun deposit(
        wallet_owner: address,
        amount: U256
    ) acquires Wallet {
        let sender = sender();
        let wallet = borrow_global_mut<Wallet>(wallet_owner);
        let Coin { value } = withdraw_from(wallet.coin_address, sender, amount);
        wallet.coins.value = add(wallet.coins.value, value);
        let deposit = Deposit {
            sender: sender,
            amount: amount,
            balance: wallet.coins.value
        };
        emit(deposit);
    }

    #[callable(sig=b"withdraw()")]
    public fun withdraw(
    ) acquires Wallet {
        let owner = sender();
        let wallet = borrow_global_mut<Wallet>(owner);
        assert!(owner == wallet.owner, 0);

        let val = wallet.coins.value;
        wallet.coins.value = zero();
        let coins = Coin { value: val };

        let withdraw = Withdraw {
            sender: owner,
            amount: coins.value
        }; 

        coin_deposit(wallet.coin_address, wallet.owner, coins);

        emit(withdraw);
    }

    #[callable(sig=b"createTransaction(address,uint256,string) returns (uint64)")]
    public fun create_transaction(
        to: address,
        value: U256,
        data: vector<u8>
    ): u64 acquires Wallet {
        let owner = sender();
        let wallet = borrow_global_mut<Wallet>(owner);
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

    #[callable(sig=b"executeTransaction(uint64)")]
    public fun execute_transaction(
        tx_id: u64
    ) acquires Wallet {
        let owner = sender();
        let wallet = borrow_global_mut<Wallet>(owner);
        assert!(owner == wallet.owner, 1);

        let transaction = vector::borrow_mut(&mut wallet.transactions, tx_id);
        
        assert!(transaction.executed == false, 2);
        assert!(le(transaction.value, wallet.coins.value), 3);
        transaction.executed = true;

        wallet.coins.value = sub(wallet.coins.value, transaction.value);
        
        coin_deposit(
            wallet.coin_address,
            transaction.to,
            Coin { value: transaction.value }
        );
        let execute_transaction = ExecuteTransaction {
            owner: owner,
            tx_id: tx_id
        };
        emit(execute_transaction);
    }
}