#[evm_contract]
module Evm::escrow_original {
    use Evm::Evm::{sign, self, sender /*emit, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, eq, add, sub /*add, sub, le*/};

    #[external(sig=b"withdrawFrom(address,uint256) returns (Coin)")]
    public native fun withdraw_from (contract: address, acc: address, amount: U256): Coin;

    #[external(sig=b"deposit(address,Coin)")]
    public native fun coin_deposit(contract: address, to: address, coin: Coin);

    #[abi_struct(sig=b"Coin(uint256)")]
    struct Coin has key, store {
        value: U256
    }

    struct Escrow has key {
        coin_address: address,
        state: u64,
        buyer: address,
        seller: address,
        amount: U256,
        coins: Coin
    }

    #[create(sig=b"create(address,address,uint256)")]
    public fun create(
        coin_address: address,
        buyer: address,
        amount: U256,
    ) {
        let seller = sender();
        let coin = withdraw_from(coin_address, seller, zero());
        let state = Escrow {
            coin_address,
            state: 0,
            buyer,
            seller,
            amount,
            coins: coin,
        };
        move_to(&sign(self()), state);
    }

    #[callable(sig=b"deposit(uint256)")]
    public fun deposit(
        amount: U256
    ) acquires Escrow {
        let buyer = sender();
        let escrow = borrow_global_mut<Escrow>(self());
        assert!(buyer == escrow.buyer, 0);
        assert!(eq(amount, escrow.amount), 0);
        let Coin { value } = withdraw_from(escrow.coin_address, buyer, amount);
        escrow.coins.value = add(escrow.coins.value, value);
        escrow.state = 1;
    }

    #[callable(sig=b"pay()")]
    public fun pay(
    ) acquires Escrow {
        let buyer = sender();
        let escrow = borrow_global_mut<Escrow>(self());
        assert!(buyer == escrow.buyer, 0);
        assert!(escrow.state == 1, 0);
        let val = escrow.coins.value;
        escrow.coins.value = zero();
        coin_deposit(escrow.coin_address, escrow.seller, Coin { value: val });
        escrow.state = 2;
    }

    #[callable(sig=b"refund()")]
    public fun refund() acquires Escrow {
        let seller = sender();
        let escrow = borrow_global_mut<Escrow>(self());
        assert!(seller == escrow.seller, 0);
        assert!(escrow.state == 1, 0);
        let val = escrow.coins.value;
        escrow.coins.value = zero();
        coin_deposit(escrow.coin_address, escrow.buyer, Coin { value: val });
        escrow.state = 3;
    }
}