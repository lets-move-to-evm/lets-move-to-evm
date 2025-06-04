//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
    function dropRes(uint256) external;
}

interface IUq64x64 is IProtectionLayerV2 {
    function encode(uint64) external returns (uint256);
    function decode(uint256) external returns (uint64);
    function toU128(uint256) external returns (uint128);
    function mul(uint256, uint64) external returns (uint256);
    function div(uint256, uint64) external returns (uint256);
    function fraction(uint64, uint64) external returns (uint256);
    function compare(uint256, uint256) external returns (int8);
    function isZero(uint256) external returns (bool);
}

contract Uq64x64Test {
    IUq64x64 public immutable uq64x64;

    constructor(address _nav) {
        uq64x64 = IUq64x64(_nav);
    }

    function encodeTest(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 encoded = uq64x64.encode(47);
        uq64x64.dropRes(encoded);
    }

    function decodeTest(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 encoded = uq64x64.encode(47);
        uq64x64.decode(encoded);
    }

    function toU128Test(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 encoded = uq64x64.encode(47);
        uq64x64.toU128(encoded);
    }

    function mulTest(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 encoded = uq64x64.encode(47);
        uint256 res = uq64x64.mul(encoded, 47);
        uq64x64.dropRes(res);
    }
    function divTest(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 encoded = uq64x64.encode(47);
        uint256 res = uq64x64.div(encoded, 47);
        uq64x64.dropRes(res);
    }
    function fractionTest(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 res = uq64x64.fraction(47, 47);
        uq64x64.dropRes(res);
    }
    function compareTest(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 encoded1 = uq64x64.encode(47);
        uint256 encoded2 = uq64x64.encode(47);
        uq64x64.compare(encoded1, encoded2);
        uq64x64.dropRes(encoded1);
        uq64x64.dropRes(encoded2);
    }

    function isZeroTest(address signer) public {
        require(msg.sender == address(uq64x64), 'Unauthorized');
        uint256 encoded = uq64x64.encode(1);
        uq64x64.isZero(encoded);
        uq64x64.dropRes(encoded);
    }
}
