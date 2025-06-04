#[evm_contract]
module Evm::math2 {
    #[callable(sig=b"sqrt(uint128) returns (uint128)")]
    /// babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    public fun sqrt(y: u128): u128 {
        if (y < 4) {
            if (y == 0) {
                0u128
            } else {
                1u128
            }
        } else {
            let z = y;
            let x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            };
            z
        }
    }

    #[callable(sig=b"min(uint128,uint128) returns (uint128)")]
    public fun min(a: u128, b: u128): u128 {
        if (a > b) b else a
    }

    #[callable(sig=b"maxU64(uint64,uint64) returns (uint64)")]
    public fun max_u64(a: u64, b: u64): u64 {
        if (a < b) b else a
    }

    #[callable(sig=b"max(uint128,uint128) returns (uint128)")]
    public fun max(a: u128, b: u128): u128 {
        if (a < b) b else a
    }

    #[callable(sig=b"pow(uint128,uint8) returns (uint128)")]
    public fun pow(base: u128, xp: u8): u128 {
        let result = 1u128;
        loop {
            if (xp & 1 == 1) { result = result * base; };
            xp = xp >> 1;
            base = base * base;
            if (xp == 0u8) { break };
        };
        result
    }

    // ================ Tests ================
    #[test]
    public fun sqrt_works() {
        assert!(sqrt(4) == 2, 0);
    }
    #[test]
    public fun max_works() {
        assert!(max(4, 12) == 12, 0);
    }

    #[test]
    public fun pow_works() {
        assert!(pow(10, 8) == 100000000, 0);
        assert!(pow(9, 2) == 81, 0);
        assert!(pow(9, 0) == 1, 0);
        assert!(pow(1, 100) == 1, 0);
    }
}