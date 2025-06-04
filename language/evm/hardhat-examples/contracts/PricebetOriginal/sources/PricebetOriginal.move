#[evm_contract]
module Evm::price_bet_original {
    use Evm::Evm::{sign, self, block_number, sender /*sender, address_of, require address_of,*/};
    use Evm::U256::{U256, ge, lt, eq, add, zero /*gt, add, sub, zero, le*/};

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

    struct PriceBet has key {
        coin_address: address,
        exchange_address: address,
        deadline_block: U256,
        exchange_rate: U256,
        initial_pot: U256,
        pot: Coin,
        owner: address,
        player: address,
    }

    #[create(sig=b"constructor(address,address,uint256,uint256,uint256)")]
    public fun create(
        coin_address: address,
        exchange_address: address,
        deadline: U256,
        exchange_rate: U256,
        initial_pot: U256,
    ) {
        let owner = sender();
        let coin = withdraw_from(coin_address, owner, initial_pot);
        let state = PriceBet {
            coin_address: coin_address,
            exchange_address: exchange_address,
            deadline_block: deadline,
            exchange_rate: exchange_rate,
            initial_pot: initial_pot,
            pot: coin,
            owner: owner,
            player: @0x0,
        };
        move_to(&sign(self()), state);
    }

    #[callable(sig=b"join(uint256)")]
    public fun join(
        bet: U256
    ) acquires PriceBet {
        let partecipant = sender();
        let price_bet = borrow_global_mut<PriceBet>(self());
        assert!(price_bet.player == @0x0, 0);
        assert!(eq(bet, price_bet.initial_pot), 0);

        price_bet.player = partecipant;

        let Coin { value } = withdraw_from(price_bet.coin_address, partecipant, bet);
        price_bet.pot.value = add(price_bet.pot.value, value);
    }

    #[callable(sig=b"win()")]
    public fun win(
    ) acquires PriceBet {
        let player = sender();
        let price_bet = borrow_global_mut<PriceBet>(self());
        assert!(player == price_bet.player, 1);
        assert!(lt(block_number(), price_bet.deadline_block), 2);

        let exchange_rate = get_exchange_rate(price_bet.exchange_address);
        assert!(ge(exchange_rate, price_bet.exchange_rate), 3);
        let val = price_bet.pot.value;
        price_bet.pot.value = zero();
        coin_deposit(price_bet.coin_address, price_bet.player, Coin { value: val });
    }

    #[callable(sig=b"timeout()")]
    public fun timeout() acquires PriceBet {
        let price_bet = borrow_global_mut<PriceBet>(self());
        assert!(ge(block_number(), price_bet.deadline_block), 0);
        let val = price_bet.pot.value;
        price_bet.pot.value = zero();
        coin_deposit(price_bet.coin_address, price_bet.owner, Coin { value: val });
    }
}