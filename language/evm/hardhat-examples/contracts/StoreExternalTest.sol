//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
}

interface IStoreExternal is IProtectionLayerV2 {
    function storeS1(uint256) external;
    function createS1(bool) external returns (uint256);
    function storeS2(uint256) external;
    function createS2(uint256) external returns (uint256);
}

contract StoreExternalTestV1 {
    struct Wrapper {
        uint256 res;
    }

    event CbData(bytes data);
    event Entered(address signer);
    event Success(bool success);
    event Fail(bool success);
    event Fallback(bytes data);
    event Coin(uint256 value);
    event Balance(uint256 value);

    IStoreExternal public immutable storeExternal;

    mapping(address => Wrapper) public wrappers;

    constructor(address _storeExternal) {
        storeExternal = IStoreExternal(_storeExternal);
    }

    function createS1(address signer) public {
        require(msg.sender == address(storeExternal), 'Unauthorized');
        uint256 resId = storeExternal.createS1(true);
        wrappers[signer] = Wrapper(resId);
        storeExternal.storeExternal(resId);
    }

    function storeS1(address signer) public {
        require(msg.sender == address(storeExternal), 'Unauthorized');
        uint256 resId = wrappers[signer].res;
        storeExternal.unstoreExternal(resId);
        storeExternal.storeS1(resId);
    }

    function createS2(address signer) public {
        require(msg.sender == address(storeExternal), 'Unauthorized');
        uint256 resId = storeExternal.createS2(0);
        wrappers[signer] = Wrapper(resId);
        storeExternal.storeExternal(resId);
    }

    function storeS2(address signer) public {
        require(msg.sender == address(storeExternal), 'Unauthorized');
        uint256 resId = wrappers[signer].res;
        storeExternal.unstoreExternal(resId);
        storeExternal.storeS2(resId);
    }

    /********** Encoding functions for testing **********/

    function createEncoding() public view returns (bytes memory) {
        return abi.encodeCall(this.createS2, msg.sender);
    }

    function storeEncoding() public view returns (bytes memory) {
        return abi.encodeCall(this.storeS2, msg.sender);
    }
}
