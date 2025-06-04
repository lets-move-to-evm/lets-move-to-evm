#[evm_contract]
module Evm::price_bet {
    use Evm::Evm::{sign, self, block_number /*sender, address_of, require address_of,*/};
    use Evm::U256::{U256, ge, lt, eq /*gt, add, sub, zero, le*/};

    #[external(sig=b"withdraw(uint256) returns (uint256)")]
    public native fun withdraw (contract: address, amount: U256): U256;

    #[external(sig=b"unstoreExternal(uint256)")]
    public native fun unstore_external(contract: address, coin: U256);

    #[external(sig=b"deposit(address,uint256)")]
    public native fun deposit(contract: address, to: address, coin: U256);

    #[external(sig=b"storeExternal(uint256)")]
    public native fun store_external(contract: address, coin: U256);

    #[external(sig=b"coinValue(uint256) returns (uint256)")]
    public native fun coin_value(contract: address, coin: U256): U256;

    #[external(sig=b"merge(uint256,uint256)")]
    public native fun merge(contract: address, coin1: U256, coin2: U256);

    #[external(sig=b"getSigner() returns (address)")]
    public native fun get_signer(contract: address): address;

    #[external(sig=b"getExchangeRate() returns (uint256)")]
    public native fun get_exchange_rate(contract: address): U256;

    struct PriceBet has key {
        coin_address: address,
        exchange_address: address,
        deadline_block: U256,
        exchange_rate: U256,
        initial_pot: U256,
        pot: CoinId,
        owner: address,
        player: address,
    }

    struct CoinId has store {
        id: U256,
    }

    #[callable(sig=b"create(address,address,address,uint256,uint256,uint256)")]
    public fun create(
        coin_address: address,
        exchange_address: address,
        owner: address,
        deadline: U256,
        exchange_rate: U256,
        initial_pot: U256,
    ) {
        assert!(owner == get_signer(coin_address), 0);
        let coin = withdraw(coin_address, initial_pot);
        store_external(coin_address, coin);
        let state = PriceBet {
            coin_address: coin_address,
            exchange_address: exchange_address,
            deadline_block: deadline,
            exchange_rate: exchange_rate,
            initial_pot: initial_pot,
            pot: CoinId { id: coin },
            owner: owner,
            player: @0x0,
        };
        move_to(&sign(self()), state);
    }

    #[callable(sig=b"join(address,uint256)")]
    public fun join(
        partecipant: address,
        bet: U256
    ) acquires PriceBet {
        let price_bet = borrow_global_mut<PriceBet>(self());
        assert!(partecipant == get_signer(price_bet.coin_address), 0);
        assert!(price_bet.player == @0x0, 0);
        assert!(eq(bet, price_bet.initial_pot), 0);

        price_bet.player = partecipant;

        let coin = withdraw(price_bet.coin_address, bet);
        merge(price_bet.coin_address, price_bet.pot.id, coin);
    }

    #[callable(sig=b"win(address)")]
    public fun win(
        player: address
    ) acquires PriceBet {
        let price_bet = borrow_global_mut<PriceBet>(self());
        assert!(player == get_signer(price_bet.coin_address), 0);
        assert!(player == price_bet.player, 1);
        assert!(lt(block_number(), price_bet.deadline_block), 2);

        let exchange_rate = get_exchange_rate(price_bet.exchange_address);
        assert!(ge(exchange_rate, price_bet.exchange_rate), 3);
        unstore_external(price_bet.coin_address, price_bet.pot.id);
        deposit(price_bet.coin_address, price_bet.player, price_bet.pot.id);
    }

    #[callable(sig=b"timeout()")]
    public fun timeout() acquires PriceBet {
        let price_bet = borrow_global_mut<PriceBet>(self());
        assert!(ge(block_number(), price_bet.deadline_block), 0);
        unstore_external(price_bet.coin_address, price_bet.pot.id);
        deposit(price_bet.coin_address, price_bet.owner, price_bet.pot.id);
    }
}