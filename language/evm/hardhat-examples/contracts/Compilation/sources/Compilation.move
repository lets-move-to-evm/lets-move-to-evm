#[evm_contract]
module Evm::compilation {
    use Evm::Evm::{sign};
    use Evm::U256::{Self, U256, zero, sub, add, u256_from_u128, lt};

    struct Simple has key {
        a: U256
    }

    /*
    fun create(a: u64): Simple {
        Simple {
            a
        }
    }

    fun write(acc: address, s: Simple) {
        move_to(&sign(acc), s);
    }
    */
    
    fun read_mut(acc: address): U256 acquires Simple {
        let s = borrow_global_mut<Simple>(acc);
        s.a
    }

    fun read_immut(acc: address): U256 acquires Simple {
        let s = borrow_global<Simple>(acc);
        s.a
    }

    
    // THIS DOES NOT WORK
    /*
    fun read_mut_addr(addr: address): &mut Simple acquires Simple {
        let s = borrow_global_mut<Simple>(addr);
        s
    }
    */
    /*
     THIS DOES NOT WORK
    
    fun swap(addr1: address, addr2: address) acquires Simple {
        let s1 = borrow_global_mut<Simple>(addr1);
        let s2 = borrow_global_mut<Simple>(addr2);
        let temp = s1.a;
        s1.a = s2.a;
        s2.a = temp;
    }
    */

    fun get(addr: address): Simple acquires Simple {
        move_from<Simple>(addr)
    }

    fun multiple_get(addr1: address, addr2: address): (Simple, Simple) acquires Simple {
        let s1 = move_from<Simple>(addr1);
        let s2 = move_from<Simple>(addr2);
        (s1, s2)
    }

    fun delete(acc: address) acquires Simple {
        let s = get(acc);
        destroy(s);
    }

    fun destroy(s: Simple) {
        let Simple { a: _ } = s;
    }

    fun edit(ref: &mut Simple): &mut Simple {
        ref.a = u256_from_u128(10);
        ref
    }

    /*
    fun read_mut_addr(addr: address): &mut Simple acquires Simple {
        borrow_global_mut<Simple>(addr)
    }
    */

    /*
    fun give_me_ref() {
        let s = Simple {
            a: 10
        };
        let mut_ref = &mut s;
        edit(mut_ref);
        let Simple { a: _ } = s;
    }
    */

    /*
    fun modify_stuff(acc: address) acquires Simple {
        let ref = read_mut_addr(acc);
        writeMutable(ref);
    }
    */
    #[callable(sig=b"main(address,uint256,uint256,uint256)returns(uint256)")]
    public fun main (acc: address, b: U256, c: U256, d: U256): U256 acquires Simple {
        let a = b;
        if (lt(a, u256_from_u128(10))) {
            a = add(c, d);
        };
        let s = Simple {
            a
        };
        move_to(&sign(acc), s);
        let a = read_mut(acc);
        a
    }


}