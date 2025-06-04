//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IBytes32Original {
    struct Bytes32 {
        bytes data;
    }
    function zeroBytes32() external returns (Bytes32 memory);
    function ffBytes32() external returns (Bytes32 memory);
    function isZero(Bytes32 memory) external returns (bool);
    function toBytes32(bytes memory) external returns (Bytes32 memory);
    function fromBytes32(Bytes32 memory) external returns (bytes memory);
    function fromAddress(address) external returns (Bytes32 memory);
}

contract Bytes32OriginalTest {
    IBytes32Original public immutable bytes32Contract;

    constructor(address _nav) {
        bytes32Contract = IBytes32Original(_nav);
    }

    function zeroBytes32Test(address signer) public {
        IBytes32Original.Bytes32 memory bytesId = bytes32Contract.zeroBytes32();
    }

    function ffBytes32Test(address signer) public {
        IBytes32Original.Bytes32 memory bytesId = bytes32Contract.ffBytes32();
    }

    function isZeroTest(address signer) public {
        IBytes32Original.Bytes32 memory bytesId = bytes32Contract.zeroBytes32();
        bool res = bytes32Contract.isZero(bytesId);
    }

    function toBytes32Test(address signer) public {
        bytes memory bytesData = new bytes(32);
        IBytes32Original.Bytes32 memory bytesId = bytes32Contract.toBytes32(
            bytesData
        );
    }

    function fromBytes32Test(address signer) public {
        bytes memory bytesData = new bytes(32);
        IBytes32Original.Bytes32 memory bytesId = bytes32Contract.toBytes32(
            bytesData
        );
        bytes memory res = bytes32Contract.fromBytes32(bytesId);
    }

    function fromAddressTest(address signer) public {
        IBytes32Original.Bytes32 memory bytesId = bytes32Contract.fromAddress(
            signer
        );
    }
}
