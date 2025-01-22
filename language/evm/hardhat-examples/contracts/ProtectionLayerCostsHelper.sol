//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
}

interface IProtectionLayerCosts is IProtectionLayerV2 {
    function doNothing() external;
    function write(uint256 value) external;
    function read() external returns (uint256);
    function edit(uint256, address) external;
    function get() external returns (uint256);
    function put(uint256) external;
    function remove() external returns (uint256);
    function sink(uint256) external;
    function readRef(uint256) external returns (uint256);
    function writeRef(uint256, uint256) external;
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
}

contract ProtectionLayerCostsHelper {
    struct Wrapper {
        uint256 s;
    }
    event Log(uint256 s);

    IProtectionLayerCosts public immutable protectionLayerCosts;

    mapping(address => Wrapper) public wrappers;

    constructor(address _protectionLayerCosts) {
        protectionLayerCosts = IProtectionLayerCosts(_protectionLayerCosts);
    }

    function getAndStoreExternal(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 s = protectionLayerCosts.get();
        protectionLayerCosts.storeExternal(s);
        wrappers[signer] = Wrapper(s);
    }

    function unstoreExternalAndSink(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 s = wrappers[signer].s;
        protectionLayerCosts.unstoreExternal(s);
        protectionLayerCosts.sink(s);
    }

    function getAndPut(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 s = protectionLayerCosts.get();
        protectionLayerCosts.put(s);
    }

    function getAndSink(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 s = protectionLayerCosts.get();
        protectionLayerCosts.sink(s);
    }

    function removeAndSink(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 s = protectionLayerCosts.remove();
        protectionLayerCosts.sink(s);
    }

    function readRefTransient(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 s = protectionLayerCosts.get();
        uint256 val = protectionLayerCosts.readRef(s);
        protectionLayerCosts.put(s);
    }

    function readRefExternal(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 val = protectionLayerCosts.readRef(wrappers[signer].s);
    }

    function writeRef(address signer) public {
        // require(msg.sender == address(protectionLayerCosts), 'Unauthorized');
        uint256 s = protectionLayerCosts.get();
        protectionLayerCosts.writeRef(s, 44);
        protectionLayerCosts.put(s);
    }

    /********** Encoding functions for testing **********/

    function getAndPutEncoding() public view returns (bytes memory) {
        return abi.encodeCall(this.getAndPut, msg.sender);
    }

    // function withdrawEncoding(
    //     uint256 amount
    // ) public view returns (bytes memory) {
    //     return abi.encodeCall(this.withdraw, (msg.sender, amount));
    // }

    // function mintToEncoding(
    //     uint256 amount,
    //     address to
    // ) public view returns (bytes memory) {
    //     return abi.encodeCall(this.mintTo, (msg.sender, amount, to));
    // }

    // function depositEncoding() public view returns (bytes memory) {
    //     return abi.encodeCall(this.deposit, msg.sender);
    // }

    // function transferEncoding(
    //     uint256 amount,
    //     address to
    // ) public view returns (bytes memory) {
    //     return abi.encodeCall(this.transfer, (msg.sender, amount, to));
    // }

    // function doNothingEncoding() public view returns (bytes memory) {
    //     return abi.encodeCall(this.doNothing, ());
    // }
}
