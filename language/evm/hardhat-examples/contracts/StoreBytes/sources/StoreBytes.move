#[evm_contract]
module Evm::store_bytes {
    use Evm::Evm::{sender, sign, /*address_of,*/ protection_layer_signer_address};
    use Evm::U256::{U256, add, sub, zero, u256_from_u128};

    struct S1 has key {
        s: vector<u8>
    }

    #[callable(sig=b"storeBytes(bytes4)")]
    public fun store_bytes(value: vector<u8>) {
        let s1 = S1 { s: value };
        move_to(&sign(sender()), s1);
    }
}