//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface II64Original {
    struct I64 {
        uint64 bits;
    }
    function zero() external returns (I64 memory);
    function fromU64(uint64) external returns (I64 memory);
    function from(uint64) external returns (I64 memory);
    function fromNeg(uint64) external returns (I64 memory);
    function wrappingAdd(I64 memory, I64 memory) external returns (I64 memory);
    function add(I64 memory, I64 memory) external returns (I64 memory);
    function wrappingSub(I64 memory, I64 memory) external returns (I64 memory);
    function sub(I64 memory, I64 memory) external returns (I64 memory);
    function mul(I64 memory, I64 memory) external returns (I64 memory);
    function div(I64 memory, I64 memory) external returns (I64 memory);
    function abs(I64 memory) external returns (I64 memory);
    function absU64(I64 memory) external returns (uint64);
    function min(I64 memory, I64 memory) external returns (I64 memory);
    function max(I64 memory, I64 memory) external returns (I64 memory);
    function pow(I64 memory, uint64) external returns (I64 memory);
}

contract I64OriginalTest {
    II64Original public immutable i64Original;

    constructor(address _nav) {
        i64Original = II64Original(_nav);
    }

    function zeroTest(address signer) public {
        II64Original.I64 memory i64id = i64Original.zero();
    }

    function fromU64Test(address signer) public {
        II64Original.I64 memory i64id = i64Original.fromU64(47);
    }
    function fromTest(address signer) public {
        II64Original.I64 memory i64id = i64Original.from(47);
    }
    function fromNegTest(address signer) public {
        II64Original.I64 memory i64id = i64Original.fromNeg(47);
    }
    function wrappingAddTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.wrappingAdd(i64id1, i64id2);
    }
    function addTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.add(i64id1, i64id2);
    }
    function wrappingSubTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.wrappingSub(i64id1, i64id2);
    }
    function subTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.sub(i64id1, i64id2);
    }
    function mulTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.mul(i64id1, i64id2);
    }
    function divTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.div(i64id1, i64id2);
    }
    function absTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.abs(i64id1);
    }
    function absU64Test(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        uint64 i64id = i64Original.absU64(i64id1);
    }
    function minTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.min(i64id1, i64id2);
    }
    function maxTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id2 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.max(i64id1, i64id2);
    }
    function powTest(address signer) public {
        II64Original.I64 memory i64id1 = i64Original.fromU64(44);
        II64Original.I64 memory i64id = i64Original.pow(i64id1, 2);
    }
}
