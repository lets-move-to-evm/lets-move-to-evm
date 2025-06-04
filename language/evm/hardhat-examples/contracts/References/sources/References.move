#[evm_contract]
module Evm::references {
    
    use Evm::U256::{U256, add, sub, zero, u256_from_u128, le};


    #[callable(sig=b"get_ref(uint256)"), view]
    public fun get_ref(int_ref: &U256) {
        int_ref;
    }
}