#[evm_contract]
module Evm::htlc {
    // use Evm::Evm::{sign, self, keccak256, block_timestamp /*emit, sender, address_of, require address_of,*/};
    // use Evm::U256::{U256, zero, eq, ge/*add, sub, le*/};
    // use std::vector;

    // #[external(sig=b"withdraw(uint256) returns (uint256)")]
    // public native fun coin_withdraw (contract: address, amount: U256): U256;

    // #[external(sig=b"unstoreExternal(uint256)")]
    // public native fun unstore_external(contract: address, coin: U256);

    // #[external(sig=b"deposit(address,uint256)")]
    // public native fun coin_deposit(contract: address, to: address, coin: U256);

    // #[external(sig=b"storeExternal(uint256)")]
    // public native fun store_external(contract: address, coin: U256);

    // #[external(sig=b"coinValue(uint256) returns (uint256)")]
    // public native fun coin_value(contract: address, coin: U256): U256;

    // #[external(sig=b"merge(uint256,uint256)")]
    // public native fun merge(contract: address, coin1: U256, coin2: U256);

    // #[external(sig=b"extract(uint256,uint256) returns (uint256)")]
    // public native fun extract(contract: address, coin: U256, amount: U256): U256;

    // #[external(sig=b"getSigner() returns (address)")]
    // public native fun get_signer(contract: address): address;

    // struct CoinId has store {
    //     id: U256,
    // }

    // struct HTLC has key {
    //     coin_address: address,
    //     owner: address,
    //     verifier: address,
    //     hash: vector<u8>,
    //     reveal_timeout: U256,
    //     coins: CoinId,
    // }

    // #[callable(sig=b"create(address,address,address,bytes,uint256,uint256)")]
    // public fun create(
    //     coin_address: address,
    //     owner: address,
    //     verifier: address,
    //     hash: vector<u8>,
    //     reveal_timeout: U256,
    //     amount: U256
    // ) {
    //     assert!(owner == get_signer(coin_address), 0);
    //     let coins = coin_withdraw(coin_address, amount);
    //     store_external(coin_address, coins);
    //     let state = HTLC {
    //         coin_address,
    //         owner,
    //         verifier,
    //         hash,
    //         reveal_timeout,
    //         coins: CoinId { id: coins },
    //     };
    //     move_to(&sign(self()), state);
    // }

    // #[callable(sig=b"reveal(address,bytes)")]
    // public fun reveal(
    //     owner: address,
    //     secret: vector<u8>
    // ) acquires HTLC {
    //     let htlc = borrow_global_mut<HTLC>(self());
    //     assert!(owner == get_signer(htlc.coin_address), 0);
    //     assert!(owner == htlc.owner, 0);

    //     let hash = keccak256(secret);
    //     assert!(vector::length(&hash) == vector::length(&htlc.hash), 0);
    //     let i = 0;
    //     while (i < vector::length(&hash)) {
    //         assert!(*vector::borrow<u8>(&hash, i) == *vector::borrow<u8>(&htlc.hash, i), 0);
    //         i = i + 1;
    //     };
    //     unstore_external(htlc.coin_address, htlc.coins.id);
    //     coin_deposit(htlc.coin_address, htlc.owner, htlc.coins.id);
    // }

    // #[callable(sig=b"timeout(address)")]
    // public fun timeout(
    //     verifier: address
    // ) acquires HTLC {
    //     let htlc = borrow_global_mut<HTLC>(self());
    //     assert!(verifier == get_signer(htlc.coin_address), 0);
    //     assert!(verifier == htlc.verifier, 0);
    //     assert!(ge(block_timestamp(), htlc.reveal_timeout), 0);
    //     unstore_external(htlc.coin_address, htlc.coins.id);
    //     coin_deposit(htlc.coin_address, htlc.verifier, htlc.coins.id);
    // }
}