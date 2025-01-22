#[evm_contract]
module Evm::MyCoin {
    use Evm::Evm::{sender, sign};
    use Evm::U256::{U256, zero, sub, add, u256_from_u128};

    struct Coin has key {
        amount: U256,
    }

    #[create(sig=b"constructor()")]
    public fun create(){
        mint(u256_from_u128(100));
    }

    #[callable(sig=b"mint(uint256)")]
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
        let from_coin = withdraw(amount);
        deposit(to, from_coin);
    }

    #[callable(sig=b"balanceOf(address)returns(uint256)"), view]
    public fun balanceOf(owner: address): U256 acquires Coin {
        let coin = borrow_global<Coin>(owner);
        coin.amount
    }

    #[callable(sig=b"withdraw(uint256) returns (uint256)")]
    public fun withdraw(amount: U256): Coin acquires Coin {
        let coin = borrow_global_mut<Coin>(sender());
        coin.amount = sub(coin.amount, amount);
        Coin { amount }
    }

    #[callable(sig=b"deposit(address,uint256)")]
    public fun deposit(to: address, coin: Coin) acquires Coin {
        let dest_coin = borrow_global_mut<Coin>(to);
        let Coin{ amount } = coin;
        dest_coin.amount = add(dest_coin.amount, amount);
    }
}