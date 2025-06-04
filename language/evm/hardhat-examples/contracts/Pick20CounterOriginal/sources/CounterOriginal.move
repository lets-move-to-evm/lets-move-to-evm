#[evm_contract]
module Evm::counter_original {
    use Evm::Evm::{sender, sign};

    struct Counter has key {
        value: u64
    }

    struct Price has key {
        value: u64,
        dec: u8,
    }

    #[callable(sig=b"createCounter()")]
    entry fun create_counter() {
        let admin_addr = sender();
        let counter = Counter { value: 0 };
        move_to<Counter>(&sign(admin_addr), counter);
    }

    #[callable(sig=b"pushCounter(uint64)")]
    entry fun push_counter(value: u64) acquires Counter {
        let addr = sender();
        let counter = borrow_global_mut<Counter>(addr);
        counter.value = value;
    }

    #[callable(sig=b"createPrice()")]
    entry fun create_price() {
        let admin_addr = sender();
        let price = Price { value: 0, dec: 0 };
        move_to(&sign(admin_addr), price);
    }

    #[callable(sig=b"pushPrice(uint64,uint8)")]
    entry fun push_price(value: u64, dec: u8) acquires Price {
        let addr = sender();
        let price = borrow_global_mut<Price>(addr);
        price.value = value;
        price.dec = dec;
    }
}
