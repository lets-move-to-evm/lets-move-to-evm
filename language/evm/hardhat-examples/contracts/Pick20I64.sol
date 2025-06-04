//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
    function dropRes(uint256) external;
}

interface II64 is IProtectionLayerV2 {
    function zero() external returns (uint256);
    function fromU64(uint64) external returns (uint256);
    function from(uint64) external returns (uint256);
    function fromNeg(uint64) external returns (uint256);
    function wrappingAdd(uint256, uint256) external returns (uint256);
    function add(uint256, uint256) external returns (uint256);
    function wrappingSub(uint256, uint256) external returns (uint256);
    function sub(uint256, uint256) external returns (uint256);
    function mul(uint256, uint256) external returns (uint256);
    function div(uint256, uint256) external returns (uint256);
    function abs(uint256) external returns (uint256);
    function absU64(uint256) external returns (uint64);
    function min(uint256, uint256) external returns (uint256);
    function max(uint256, uint256) external returns (uint256);
    function pow(uint256, uint64) external returns (uint256);
}

contract I64Test {
    II64 public immutable i64;

    constructor(address _nav) {
        i64 = II64(_nav);
    }

    function zeroTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id = i64.zero();
        i64.dropRes(i64id);
    }

    function fromU64Test(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id = i64.fromU64(47);
        i64.dropRes(i64id);
    }
    function fromTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id = i64.from(47);
        i64.dropRes(i64id);
    }
    function fromNegTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id = i64.fromNeg(47);
        i64.dropRes(i64id);
    }
    function wrappingAddTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.wrappingAdd(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function addTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.add(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function wrappingSubTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.wrappingSub(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function subTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.sub(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function mulTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.mul(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function divTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.div(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function absTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id = i64.abs(i64id1);
        i64.dropRes(i64id);
    }
    function absU64Test(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint64 i64id = i64.absU64(i64id1);
    }
    function minTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.min(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function maxTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id2 = i64.fromU64(44);
        uint256 i64id = i64.max(i64id1, i64id2);
        i64.dropRes(i64id);
    }
    function powTest(address signer) public {
        require(msg.sender == address(i64), 'Unauthorized');
        uint256 i64id1 = i64.fromU64(44);
        uint256 i64id = i64.pow(i64id1, 2);
        i64.dropRes(i64id);
    }
}
