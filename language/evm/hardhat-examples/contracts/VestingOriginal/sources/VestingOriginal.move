#[evm_contract]
module Evm::vesting_original {
    use Evm::Evm::{sign, self, block_timestamp, sender /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, lt, gt, sub, div, mul, add /*add, sub, le*/};

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

    struct Vesting has key {
        coin_address: address,
        beneficiary: address,
        released: U256,
        start: U256,
        duration: U256,
        coins: Coin
    }

    #[callable(sig=b"init(address,address,uint256,uint256,uint256)")]
    public fun init(
        beneficiary: address,
        coin_address: address,
        start: U256,
        duration: U256,
        amount: U256,
    ) {
        let owner = sender();
        let coin = withdraw_from(coin_address, owner, amount);
        
        let vesting = Vesting {
            coin_address,
            beneficiary,
            released: zero(),
            start,
            duration,
            coins: coin,
        };
        move_to(&sign(self()), vesting);
    }

    #[callable(sig=b"release()")]
    public fun release() acquires Vesting {
        let vesting = borrow_global_mut<Vesting>(self());
        
        let releasable_amount = releasable_priv(vesting);

        vesting.released = add(vesting.released, releasable_amount);
        vesting.coins.value = sub(vesting.coins.value, releasable_amount);
        coin_deposit(vesting.coin_address, vesting.beneficiary, Coin { value: releasable_amount });
    }

    #[callable(sig=b"releasable() returns (uint256)")]
    public fun releasable(): U256 acquires Vesting {
        let vesting = borrow_global<Vesting>(self());
        sub(vested_amount_priv(vesting), vesting.released)
    }

    #[callable(sig=b"vestedAmount() returns (uint256)")]
    public fun vested_amount(): U256 acquires Vesting {
        let vesting = borrow_global<Vesting>(self());
        vesting_schedule(add(vesting.coins.value, vesting.released), block_timestamp())
    }

    #[callable(sig=b"vestingSchedule(uint256,uint256) returns (uint256)")]
    public fun vesting_schedule(
        total_amount: U256,
        current_time: U256,
    ): U256 acquires Vesting {
        let vesting = borrow_global<Vesting>(self());
        if (lt(current_time, vesting.start)) {
            zero()
        } else if (gt(current_time, add(vesting.start, vesting.duration))) {
            total_amount
        } else {
            div(
                mul(total_amount, sub(current_time, vesting.start)),
                vesting.duration
            )
        }
    }

    fun releasable_priv(vesting: &Vesting): U256 {
        sub(vested_amount_priv(vesting), vesting.released)
    }

    fun vested_amount_priv(vesting: &Vesting): U256 {
        vesting_schedule_priv(
            vesting,
            add(vesting.coins.value, vesting.released),
            block_timestamp()
        )
    }

    fun vesting_schedule_priv(
        vesting: &Vesting,
        total_amount: U256,
        current_time: U256,
    ): U256 {
        if (lt(current_time, vesting.start)) {
            zero()
        } else if (gt(current_time, add(vesting.start, vesting.duration))) {
            total_amount
        } else {
            div(
                mul(total_amount, sub(current_time, vesting.start)),
                vesting.duration
            )
        }
    }
}