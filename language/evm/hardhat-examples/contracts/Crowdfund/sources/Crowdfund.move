#[evm_contract]
module Evm::crowdfund {
    use Evm::Evm::{sign, self, block_timestamp /*emit, sender, address_of, require address_of,*/};
    use Evm::U256::{U256, gt, lt, zero /*add, sub, le*/};

    #[external(sig=b"withdraw(uint256) returns (uint256)")]
    public native fun coin_withdraw (contract: address, amount: U256): U256;

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

    #[external(sig=b"extract(uint256,uint256) returns (uint256)")]
    public native fun extract(contract: address, coin: U256, amount: U256): U256;

    #[external(sig=b"getSigner() returns (address)")]
    public native fun get_signer(contract: address): address;

    struct CoinId has store {
        id: U256,
    }

    struct Crowdfund has key {
        coin_address: address,
        end_donate: U256,
        goal: U256,
        recevier: address,
        funding: CoinId
    }

    struct Receipt has key {
        amount: U256,
    }

    #[callable(sig=b"create(address,uint256,uint64,address)")]
    public fun create(
        coin_address: address, 
        end_donate: U256, 
        goal: U256, 
        recevier: address
    ) {
        let coin = coin_withdraw(coin_address, zero());
        store_external(coin_address, coin);
        let state = Crowdfund{
            coin_address: coin_address,
            end_donate: end_donate,
            goal: goal,
            recevier: recevier,
            funding: CoinId { id: coin }
        };
        move_to(&sign(self()), state);
    }

    #[callable(sig=b"donate(address, uint256)")]
    public fun donate(acc: address, amount: U256) acquires Crowdfund {
        let crowdfund = borrow_global_mut<Crowdfund>(self());
        assert!(acc == get_signer(crowdfund.coin_address), 0);
        assert!(lt(block_timestamp(), crowdfund.end_donate), 0);
        assert!(gt(amount, zero()), 0);
        let coin = coin_withdraw(crowdfund.coin_address, amount);
        merge(crowdfund.coin_address, crowdfund.funding.id, coin);
        move_to(&sign(acc), Receipt { amount });
    }

    #[callable(sig=b"withdraw(address)")]
    public fun withdraw(acc: address) acquires Crowdfund {
        let crowdfund = borrow_global_mut<Crowdfund>(self());
        assert!(acc == get_signer(crowdfund.coin_address), 0);
        assert!(gt(block_timestamp(), crowdfund.end_donate), 0);
        assert!(gt(coin_value(crowdfund.coin_address, crowdfund.funding.id), crowdfund.goal), 0);
        unstore_external(crowdfund.coin_address, crowdfund.funding.id);
        deposit(crowdfund.coin_address, crowdfund.recevier, crowdfund.funding.id);
    }

    #[callable(sig=b"reclaim(address)")]
    public fun reclaim(acc: address) acquires Crowdfund, Receipt {
        let crowdfund = borrow_global_mut<Crowdfund>(self());
        assert!(acc == get_signer(crowdfund.coin_address), 0);
        assert!(gt(block_timestamp(), crowdfund.end_donate), 0);

        let Receipt { amount } = move_from<Receipt>(acc);
        let coin = extract(crowdfund.coin_address, crowdfund.funding.id, amount);
        deposit(crowdfund.coin_address, acc, coin);
    }
}