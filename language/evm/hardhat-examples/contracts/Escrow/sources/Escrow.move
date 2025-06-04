#[evm_contract]
module Evm::escrow {
    use Evm::Evm::{sign, self /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, eq/*add, sub, le*/};

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

    struct Escrow has key {
        coin_address: address,
        state: u64,
        buyer: address,
        seller: address,
        amount: U256,
        coins: CoinId
    }

    #[callable(sig=b"create(address,address,address,uint256)")]
    public fun create(
        coin_address: address,
        seller: address, 
        buyer: address,
        amount: U256,
    ) {
        assert!(seller == get_signer(coin_address), 0);
        let coin = coin_withdraw(coin_address, zero());
        store_external(coin_address, coin);
        let state = Escrow {
            coin_address,
            state: 0,
            buyer,
            seller,
            amount,
            coins: CoinId { id: coin },
        };
        move_to(&sign(self()), state);
    }

    #[callable(sig=b"deposit(address,uint256)")]
    public fun deposit(
        buyer: address,
        amount: U256
    ) acquires Escrow {
        let escrow = borrow_global_mut<Escrow>(self());
        assert!(buyer == get_signer(escrow.coin_address), 0);
        assert!(buyer == escrow.buyer, 0);
        assert!(eq(amount, escrow.amount), 0);
        let coin = coin_withdraw(escrow.coin_address, amount);
        merge(escrow.coin_address, escrow.coins.id, coin);
        escrow.state = 1;
    }

    #[callable(sig=b"pay(address)")]
    public fun pay(
        buyer: address
    ) acquires Escrow {
        let escrow = borrow_global_mut<Escrow>(self());
        assert!(buyer == get_signer(escrow.coin_address), 0);
        assert!(buyer == escrow.buyer, 0);
        assert!(escrow.state == 1, 0);
        let coins = extract(escrow.coin_address, escrow.coins.id, escrow.amount);
        coin_deposit(escrow.coin_address, escrow.seller, coins);
        escrow.state = 2;
    }

    #[callable(sig=b"refund(address)")]
    public fun refund(seller: address) acquires Escrow {
        let escrow = borrow_global_mut<Escrow>(self());
        assert!(seller == get_signer(escrow.coin_address), 0);
        assert!(seller == escrow.seller, 0);
        assert!(escrow.state == 1, 0);
        let coins = extract(escrow.coin_address, escrow.coins.id, escrow.amount);
        coin_deposit(escrow.coin_address, escrow.buyer, coins);
        escrow.state = 3;
    }
}