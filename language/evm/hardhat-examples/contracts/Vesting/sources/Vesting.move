#[evm_contract]
module Evm::vesting {
    use Evm::Evm::{sign, self, block_timestamp /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, zero, lt, gt, sub, div, mul, add /*add, sub, le*/};

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

    struct Vesting has key {
        coin_address: address,
        beneficiary: address,
        released: U256,
        start: U256,
        duration: U256,
        coins: CoinId
    }

    #[callable(sig=b"init(address,address,address,uint256,uint256,uint256)")]
    public fun init(
        owner: address,
        beneficiary: address,
        coin_address: address,
        start: U256,
        duration: U256,
        amount: U256,
    ) {
        assert!(owner == get_signer(coin_address), 0);
        let coin = coin_withdraw(coin_address, amount);
        store_external(coin_address, coin);
        
        let vesting = Vesting {
            coin_address,
            beneficiary,
            released: zero(),
            start,
            duration,
            coins: CoinId { id: coin },
        };
        move_to(&sign(self()), vesting);
    }

    #[callable(sig=b"release()")]
    public fun release() acquires Vesting {
        let vesting = borrow_global_mut<Vesting>(self());
        
        let releasable_amount = releasable_priv(vesting);

        vesting.released = add(vesting.released, releasable_amount);
        let coins = extract(vesting.coin_address, vesting.coins.id, releasable_amount);
        coin_deposit(vesting.coin_address, vesting.beneficiary, coins);
    }

    #[callable(sig=b"releasable() returns (uint256)")]
    public fun releasable(): U256 acquires Vesting {
        let vesting = borrow_global<Vesting>(self());
        sub(vested_amount_priv(vesting), vesting.released)
    }

    #[callable(sig=b"vestedAmount() returns (uint256)")]
    public fun vested_amount(): U256 acquires Vesting {
        let vesting = borrow_global<Vesting>(self());
        vesting_schedule(add(coin_value(vesting.coin_address, vesting.coins.id), vesting.released), block_timestamp())
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
            add(coin_value(vesting.coin_address, vesting.coins.id), vesting.released),
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