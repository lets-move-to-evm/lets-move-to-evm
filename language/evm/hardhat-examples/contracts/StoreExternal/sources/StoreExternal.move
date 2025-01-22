#[evm_contract]
module Evm::store_external{
    use Evm::Evm::{sender, sign, /*protection_layer_signer_address*/};
    use Evm::U256::{U256};

    struct S1 has key {
        val: bool
    }

    struct S2 has key {
        val: U256
    }

    #[callable(sig=b"storeS1(uint256)")]
    public fun store_s1(s1: S1) {
        move_to(&sign(sender()), s1);
    }

    #[callable(sig=b"createS1(bool) returns (uint256)")]
    public fun create_s1(val: bool): S1 {
        S1 { val }
    }

    #[callable(sig=b"storeS2(uint256)")]
    public fun store_s2(s2: S2) {
        move_to(&sign(sender()), s2);
    }

    #[callable(sig=b"createS2(uint256) returns (uint256)")]
    public fun create_s2(val: U256): S2 {
        S2 { val }
    }
}