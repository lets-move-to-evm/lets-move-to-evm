#[evm_contract]
module Evm::full_math_u64 {

    #[callable(sig=b"mulDivFloor(uint64,uint64,uint64) returns (uint64)")]
    public fun mul_div_floor(num1: u64, num2: u64, denom: u64): u64 {
        let r = ((num1 as u128) * (num2 as u128)) / (denom as u128);
        (r as u64)
    }
    
    #[callable(sig=b"mulDivRound(uint64,uint64,uint64) returns (uint64)")]
    public fun mul_div_round(num1: u64, num2: u64, denom: u64): u64 {
        let r = (((num1 as u128) * (num2 as u128)) + ((denom as u128) >> 1)) / (denom as u128);
        (r as u64)
    }
    
    #[callable(sig=b"mulDivCeil(uint64,uint64,uint64) returns (uint64)")]
    public fun mul_div_ceil(num1: u64, num2: u64, denom: u64): u64 {
        let r = (((num1 as u128) * (num2 as u128)) + ((denom as u128) - 1)) / (denom as u128);
        (r as u64)
    }
    
    #[callable(sig=b"mulShr(uint64,uint64,uint8) returns (uint64)")]
    public fun mul_shr(num1: u64, num2: u64, shift: u8): u64 {
        let r = ((num1 as u128) * (num2 as u128)) >> shift;
        (r as u64)
    }
    
    #[callable(sig=b"mulShl(uint64,uint64,uint8) returns (uint64)")]
    public fun mul_shl(num1: u64, num2: u64, shift: u8): u64 {
        let r = ((num1 as u128) * (num2 as u128)) << shift;
        (r as u64)
    }

    #[callable(sig=b"fullMul(uint64,uint64) returns (uint128)")]
    public fun full_mul(num1: u64, num2: u64): u128 {
        ((num1 as u128) * (num2 as u128))
    }
}