// Copyright (c) The Diem Core Contributors
// Copyright (c) The Move Contributors
// SPDX-License-Identifier: Apache-2.0

// use crate::yul_functions::YulFunction::{ Malloc, Abort };

macro_rules! protection_layer_functions {
    ($($name:ident: $def:literal $(dep $dep:ident)*),* $(, )?) => {
        #[derive(PartialEq, Eq, PartialOrd, Ord, Clone, Copy, Debug, Hash)]
        #[allow(dead_code)]
        pub enum YulProtectionFunction {
            $($name,)*
        }
        impl YulProtectionFunction {
            #[allow(dead_code)]
            pub fn yule_name(self) -> String {
                match self {
                $(
                    YulProtectionFunction::$name => make_yule_name(stringify!($name)),
                )*
                }
            }
            #[allow(dead_code)]
            pub fn yule_def(self) -> String {
                match self {
                $(
                    YulProtectionFunction::$name => make_yule_def(stringify!($name), $def),
                )*
                }
            }
            #[allow(dead_code)]
            pub fn yule_deps(self) -> Vec<YulProtectionFunction> {
                match self {
                $(
                    YulProtectionFunction::$name => vec![$(YulProtectionFunction::$dep,)*],
                )*
                }
                
            }
        }
    }
}

fn make_yule_name(name: &str) -> String {
    format!("${}", name)
}

/// Helper to create definition of a Yule function.
fn make_yule_def(name: &str, body: &str) -> String {
    format!("function ${}{}", name, body)
}

protection_layer_functions! {
AbortNotProtected: "() {
    if iszero($IsProtected()) {
        $Abort2(6)
    }
}" dep IsProtected dep Abort2,
AbortProtected: "() {
    if $IsProtected() {
        $Abort2(7)
    }
}" dep IsProtected dep Abort2,
Abort2: "(code) {
    mstore(0, code)
    revert(24, 8) // TODO: store code as a string?
}",
// Protection flag functions
IsProtected: "() -> flag {
    flag := tload(0x0)
}",
Protect: "() {
    tstore(0x0, 1)
}",
Release: "() {
    tstore(0x0, 0)
}",
// Signer functions
SaveSigner: "() {
    tstore(0x1, caller())
}",
GetSigner: "() -> addr {
    addr := tload(0x1)
}",
DeleteSigner: "() {
    tstore(0x1, 0)
}",
// Protected contract functions
SaveProtectedContract: "(addr) {
    tstore(0x2, addr)
}",
GetProtectedContract: "() -> addr {
    addr := tload(0x2)
}",
DeleteProtectedContract: "() {
    tstore(0x2, 0)
}",
// Reentrancy flag functions
SetReentrancyFlag: "() {
    tstore(0x3, 1)
}",
ClearReentrancyFlag: "() {
    tstore(0x3, 0)
}",
IsReentrancyFlagSet: "() -> flag {
    flag := tload(0x3)
}",
// Hot potatoes AKA external storage functions
SizeOFH: "() -> size {
    size := tload(0x4)
}",
IncrementH: "() {
    tstore(0x4, add(tload(0x4), 1))
}",
DecrementH: "() {
    tstore(0x4, sub(tload(0x4), 1))
}",

// Transient functions
SizeOfT: "() -> size {
    size := tload(0x5)
}",
IncrementT: "() {
    tstore(0x5, add(tload(0x5), 1))
}",
DecrementT: "() {
    tstore(0x5, sub(tload(0x5), 1))
}",

NewResourceId: "() -> id {
    id := sload(0x6)
    sstore(0x6, add(id, 1))
}",

// TODO check Abort codes
// Validation function
Validate: "() -> flag {
    $AbortProtected()
    
    // check size of Hot and Transient
    if $SizeOFH() {
        $Abort2(1)
    }
    // check if reentrancy flag is set
    if $IsReentrancyFlagSet() {
        $Abort2(3)
    }
    flag := true
}" dep AbortProtected dep SizeOFH dep SizeOfT dep IsReentrancyFlagSet dep GetSigner dep GetProtectedContract dep Abort2,

// Those are needed to store type hash when a resource is returned
StoreTypeHash: "(resId, typeHash) {
    let base := $Malloc2(0x40)
    mstore(base, resId)
    mstore(add(base, 0x20), 0x00)
    let key := keccak256(base, 0x40)
    mstore(base, key)
    log0(base, 0x20)
    sstore(key, typeHash)
}" dep Malloc2,

GetTypeHash: "(resId) -> typeHash {
    let base := $Malloc2(0x40)
    mstore(base, resId)
    mstore(add(base, 0x20), 0x00)
    let key := keccak256(base, 0x40)
    mstore(base, key)
    log0(base, 0x20)
    typeHash := sload(key)
}" dep Malloc2,

RemoveTypeHash: "(resId) {
    let base := $Malloc2(0x40)
    mstore(base, resId)
    mstore(add(base, 0x20), 0x00)
    let key := keccak256(base, 0x40)
    mstore(base, key)
    log0(base, 0x20)
    sstore(key, 0)
}" dep Malloc2,

ComputeHash: "(addr, resId) -> hash {
    let base := $Malloc2(0x40)
    mstore(base, addr)
    mstore(add(base, 0x20), resId)
    hash := keccak256(base, 0x00)
}" dep Malloc2,

AbiDecodeProtectionLayer: "(headStart, dataEnd) -> value0, value1 {
    if slt(sub(dataEnd, headStart), 64) { $Abort2(7) }
    {
        let offset := 0
        value0 := $AbiDecodeAddress(add(headStart, offset), dataEnd)
    }
    {
        let offset := calldataload(add(headStart, 32))
        if gt(offset, 0xffffffffffffffff) { $Abort2(8) }
        value1 := $AbiDecodeBytesMemoryPtr(add(headStart, offset), dataEnd)
    }

}" dep Abort2 dep AbiDecodeAddress dep AbiDecodeBytesMemoryPtr,
AbiDecodeAddress: "(offset, end) -> value {
    value := calldataload(offset)
    if iszero(eq(value, $CleanupAddress(value))) { revert(0, 0) }
}" dep CleanupAddress,

AbiDecodeBytesMemoryPtr: "(offset, end) -> array {
    if iszero(slt(add(offset, 0x1f), end)) { $Abort2(12) }
    let length := calldataload(offset)
    array := $AbiDecodeAvailableLengthBytesMemoryPtr(add(offset, 0x20), length, end)
}" dep AbiDecodeAvailableLengthBytesMemoryPtr dep Abort2,
AbiDecodeAvailableLengthBytesMemoryPtr:"(src, length, end) -> array {
    array := $Malloc2($ArrayAllocationSizeBytesMemoryPtr(length))
    mstore(array, length)
    let dst := add(array, 0x20)
    if gt(add(src, length), end) { $Abort2(10) }
    $CopyCalldataToMemory(src, dst, length)
}" dep Malloc2 dep ArrayAllocationSizeBytesMemoryPtr dep CopyCalldataToMemory dep Abort2,
Malloc2: "(size) -> offs {
    offs := mload(${MEM_SIZE_LOC})
    // pad to word size
    mstore(${MEM_SIZE_LOC}, add(offs, shl(5, shr(5, add(size, 31)))))
}",
ArrayAllocationSizeBytesMemoryPtr: "(length) -> size {
    // Make sure we can allocate memory without overflow
    if gt(length, 0xffffffffffffffff) { $Abort2(11) }
    size := $RoundUpMulOf32(length)
    // add length slot
    size := add(size, 0x20)
}" dep RoundUpMulOf32 dep Abort2,
RoundUpMulOf32: "(value) -> result {
    result := and(add(value, 31), not(31))
}",
CopyCalldataToMemory: "(src, dst, length) {
    calldatacopy(dst, src, length)
    // clear end
    mstore(add(dst, length), 0)
}",
CleanupAddress: "(value) -> cleaned {
    cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
}",
}
