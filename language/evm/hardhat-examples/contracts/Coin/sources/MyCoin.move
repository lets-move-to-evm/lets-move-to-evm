#[evm_contract]
module Evm::MyCoin {
    use Evm::Evm::{self, block_number, sender, value, sign};
    use Evm::U256::{Self, U256, zero, sub, add, u256_from_u128};

    struct Coin has key {
        amount: U256,
    }

    #[create(sig=b"constructor()")]
    public fun create(){
        mint(u256_from_u128(100));
    }

    fun mint(amount: U256) {
        let coin = Coin {
            amount: amount
        };
        move_to<Coin>(&sign(sender()), coin);
    }

    #[callable(sig=b"optIn()")]
    public fun optIn() {
        let coin = Coin {
            amount: zero()
        };
        move_to<Coin>(&sign(sender()), coin);
    }

    #[callable(sig=b"transfer(address,uint256)")]
    public fun transfer(to: address, amount: U256) acquires Coin {
        let from_coin = borrow_global_mut<Coin>(sender());
        from_coin.amount = sub(from_coin.amount, amount);
        let to_coin = borrow_global_mut<Coin>(to);
        to_coin.amount = add(to_coin.amount, amount);
    }

    #[callable(sig=b"balanceOf(address)returns(uint256)"), view]
    public fun balanceOf(owner: address): U256 acquires Coin {
        let coin = borrow_global<Coin>(owner);
        coin.amount
    }
}