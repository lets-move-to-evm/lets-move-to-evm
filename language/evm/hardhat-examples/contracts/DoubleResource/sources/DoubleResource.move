#[evm_contract]
module Evm::double_resource {
    use Evm::Evm::{sender, sign, /*address_of,*/ protection_layer_signer_address};
    use Evm::U256::{U256, add, sub, zero, u256_from_u128};

    struct S1 has key {
        s: S3
    }

    struct S3 has store {
        value: U256
    }

    struct S2 has key {
        value: U256
    }

    #[callable(sig=b"getS1() returns (uint256)")]
    public fun get_s1(): S1 {
        S1 { s: S3 { value: zero() } }
    }

    #[callable(sig=b"getS2() returns (uint256)")]
    public fun get_s2(): S2 {
        S2 { value: zero() }
    }
}