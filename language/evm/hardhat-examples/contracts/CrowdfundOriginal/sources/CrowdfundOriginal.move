#[evm_contract]
module Evm::crowdfund_original {
    use Evm::Evm::{sign, self, sender, block_timestamp /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, gt, lt, zero, add, sub /* sub, le*/};

    #[external(sig=b"withdrawFrom(address,uint256) returns (Coin)")]
    public native fun withdraw_from (contract: address, acc: address, amount: U256): Coin;

    #[external(sig=b"deposit(address,Coin)")]
    public native fun deposit(contract: address, to: address, coin: Coin);

    #[abi_struct(sig=b"Coin(uint256)")]
    struct Coin has key, store {
        value: U256
    }

    struct Crowdfund has key {
        coin_address: address,
        end_donate: U256,
        goal: U256,
        recevier: address,
        funding: Coin
    }

    struct Receipt has key {
        amount: U256,
    }

    #[create(sig=b"constructor(address,uint256,uint64,address)")]
    public fun create(
        coin_address: address,
        end_donate: U256, 
        goal: U256, 
        recevier: address
    ) {
        let state = Crowdfund{
            coin_address: coin_address,
            end_donate: end_donate,
            goal: goal,
            recevier: recevier,
            funding: Coin { value: zero() }
        };
        move_to(&sign(self()), state);
    }

    #[callable(sig=b"donate(uint256)")]
    public fun donate(amount: U256) acquires Crowdfund {
        let acc = sender();
        let crowdfund = borrow_global_mut<Crowdfund>(self());
        assert!(lt(block_timestamp(), crowdfund.end_donate), 0);
        assert!(gt(amount, zero()), 0);
        let Coin { value } = withdraw_from(crowdfund.coin_address, acc, amount);
        crowdfund.funding.value = add(crowdfund.funding.value, value);
        move_to(&sign(acc), Receipt { amount });
    }

    #[callable(sig=b"withdraw()")]
    public fun withdraw() acquires Crowdfund {
        let crowdfund = borrow_global_mut<Crowdfund>(self());
        assert!(gt(block_timestamp(), crowdfund.end_donate), 0);
        assert!(gt(crowdfund.funding.value, crowdfund.goal), 0);
        let val = crowdfund.funding.value;
        crowdfund.funding.value = zero();
        deposit(crowdfund.coin_address, crowdfund.recevier, Coin { value: val });
    }

    #[callable(sig=b"reclaim()")]
    public fun reclaim() acquires Crowdfund, Receipt {
        let acc = sender();
        let crowdfund = borrow_global_mut<Crowdfund>(self());
        assert!(gt(block_timestamp(), crowdfund.end_donate), 0);

        let Receipt { amount } = move_from<Receipt>(acc);
        let val = crowdfund.funding.value;
        crowdfund.funding.value = sub(val, amount);
        deposit(crowdfund.coin_address, acc, Coin { value: amount });
    }
}