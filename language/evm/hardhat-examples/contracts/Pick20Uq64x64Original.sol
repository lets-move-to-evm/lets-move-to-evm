//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
    function dropRes(uint256) external;
}

interface IUq64x64Original is IProtectionLayerV2 {
    struct Uq64x64 {
        uint128 value;
    }
    function encode(uint64) external returns (Uq64x64 memory);
    function decode(Uq64x64 memory) external returns (uint64);
    function toU128(Uq64x64 memory) external returns (uint128);
    function mul(Uq64x64 memory, uint64) external returns (Uq64x64 memory);
    function div(Uq64x64 memory, uint64) external returns (Uq64x64 memory);
    function fraction(uint64, uint64) external returns (Uq64x64 memory);
    function compare(Uq64x64 memory, Uq64x64 memory) external returns (int8);
    function isZero(Uq64x64 memory) external returns (bool);
}

contract Uq64x64TestOriginal {
    IUq64x64Original public immutable uq64x64;

    constructor(address _nav) {
        uq64x64 = IUq64x64Original(_nav);
    }

    function encodeTest(address signer) public {
        IUq64x64Original.Uq64x64 memory encoded = uq64x64.encode(47);
    }

    function decodeTest(address signer) public {
        IUq64x64Original.Uq64x64 memory encoded = uq64x64.encode(47);
        uq64x64.decode(encoded);
    }

    function toU128Test(address signer) public {
        IUq64x64Original.Uq64x64 memory encoded = uq64x64.encode(47);
        uq64x64.toU128(encoded);
    }

    function mulTest(address signer) public {
        IUq64x64Original.Uq64x64 memory encoded = uq64x64.encode(47);
        IUq64x64Original.Uq64x64 memory res = uq64x64.mul(encoded, 47);
    }
    function divTest(address signer) public {
        IUq64x64Original.Uq64x64 memory encoded = uq64x64.encode(47);
        IUq64x64Original.Uq64x64 memory res = uq64x64.div(encoded, 47);
    }
    function fractionTest(address signer) public {
        IUq64x64Original.Uq64x64 memory res = uq64x64.fraction(47, 47);
    }
    function compareTest(address signer) public {
        IUq64x64Original.Uq64x64 memory encoded1 = uq64x64.encode(47);
        IUq64x64Original.Uq64x64 memory encoded2 = uq64x64.encode(47);
        uq64x64.compare(encoded1, encoded2);
    }

    function isZeroTest(address signer) public {
        IUq64x64Original.Uq64x64 memory encoded = uq64x64.encode(1);
        uq64x64.isZero(encoded);
    }
}
