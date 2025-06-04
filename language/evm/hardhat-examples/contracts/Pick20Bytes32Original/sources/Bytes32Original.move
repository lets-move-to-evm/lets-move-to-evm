#[evm_contract]
module Evm::bytes32_original {
    use std::bcs;
    use std::vector;

    public fun ZEROS_32_BYTES(): vector<u8> {
        x"0000000000000000000000000000000000000000000000000000000000000000"
    }

    #[abi_struct(sig=b"Bytes32(bytes)")]
    struct Bytes32 has store, drop, copy {
        bytes: vector<u8>
    }

    #[callable(sig=b"zeroBytes32() returns (Bytes32)")]
    /// Returns a Bytes32 with all bytes set to zero
    public fun zero_bytes32(): Bytes32 {
        Bytes32 { bytes: ZEROS_32_BYTES() }
    }

    #[callable(sig=b"ffBytes32() returns (Bytes32)")]
    /// Returns a Bytes32 with all bytes set to 0xff
    public fun ff_bytes32(): Bytes32 {
        Bytes32 { bytes: x"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" }
    }
 
    #[callable(sig=b"isZero(Bytes32) returns (bool)")]
    /// Returns true if the given Bytes32 is all zeros
    public fun is_zero(bytes32: Bytes32): bool {
        bytes32.bytes == ZEROS_32_BYTES()
    }

    #[callable(sig=b"toBytes32(bytes) returns (Bytes32)")]
    /// Converts a vector of bytes to a Bytes32
    /// The vector must be exactly 32 bytes long
    public fun to_bytes32(bytes: vector<u8>): Bytes32 {
        assert!(vector::length(&bytes) == 32, EINVALID_LENGTH);
        Bytes32 { bytes }
    }

    #[callable(sig=b"fromBytes32(Bytes32) returns (bytes)")]
    /// Converts a Bytes32 to a vector of bytes
    public fun from_bytes32(bytes32: Bytes32): vector<u8> {
        bytes32.bytes
    }

    #[callable(sig=b"fromAddress(address) returns (Bytes32)")]
    /// Converts an address to a Bytes32
    public fun from_address(addr: address): Bytes32 {
        let bytes = bcs::to_bytes(&addr);
        to_bytes32(bytes)
    }

    // ================================================== Error Codes =================================================

    const EINVALID_LENGTH: u64 = 1;
}
