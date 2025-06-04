//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
    function dropRes(uint256) external;
}

interface IBytes32 is IProtectionLayerV2 {
    function zeroBytes32() external returns (uint256);
    function ffBytes32() external returns (uint256);
    function isZero(uint256) external returns (bool);
    function toBytes32(bytes memory) external returns (uint256);
    function fromBytes32(uint256) external returns (bytes memory);
    function fromAddress(address) external returns (uint256);
}

contract Bytes32Test {
    IBytes32 public immutable bytes32Contract;

    constructor(address _nav) {
        bytes32Contract = IBytes32(_nav);
    }

    function zeroBytes32Test(address signer) public {
        require(msg.sender == address(bytes32Contract), 'Unauthorized');
        uint256 bytesId = bytes32Contract.zeroBytes32();
        bytes32Contract.dropRes(bytesId);
    }

    function ffBytes32Test(address signer) public {
        require(msg.sender == address(bytes32Contract), 'Unauthorized');
        uint256 bytesId = bytes32Contract.ffBytes32();
        bytes32Contract.dropRes(bytesId);
    }

    function isZeroTest(address signer) public {
        require(msg.sender == address(bytes32Contract), 'Unauthorized');
        uint256 bytesId = bytes32Contract.zeroBytes32();
        bool res = bytes32Contract.isZero(bytesId);
        bytes32Contract.dropRes(bytesId);
    }

    function toBytes32Test(address signer) public {
        require(msg.sender == address(bytes32Contract), 'Unauthorized');
        bytes memory bytesData = new bytes(32);
        uint256 bytesId = bytes32Contract.toBytes32(bytesData);
        bytes32Contract.dropRes(bytesId);
    }

    function fromBytes32Test(address signer) public {
        require(msg.sender == address(bytes32Contract), 'Unauthorized');
        bytes memory bytesData = new bytes(32);
        uint256 bytesId = bytes32Contract.toBytes32(bytesData);
        bytes memory res = bytes32Contract.fromBytes32(bytesId);
    }

    function fromAddressTest(address signer) public {
        require(msg.sender == address(bytes32Contract), 'Unauthorized');
        uint256 bytesId = bytes32Contract.fromAddress(signer);
        bytes32Contract.dropRes(bytesId);
    }
}
