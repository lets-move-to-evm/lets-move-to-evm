//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function protect(address, bytes memory) external returns (bool);
    function dropRes() external returns (uint256);
    function sink(uint256) external;
    function storeExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
}

contract ResourceDroppingTestV2 {
    struct Wrapper {
        uint256 droppedRes;
    }

    event CbData(bytes data);
    event Entered(address signer);
    event Success(bool success);
    event Fail(bool success);
    event Fallback(bytes data);
    event DroppedRes(uint256 res);

    mapping(address => bytes) public callbacks;
    mapping(address => bytes) public entered;

    IProtectionLayerV2 public immutable resourceDropping;

    mapping(address => Wrapper) public droppedResources;

    constructor(address _resourceDropping) {
        resourceDropping = IProtectionLayerV2(_resourceDropping);
    }

    function getWrapper() public view returns (Wrapper memory) {
        return droppedResources[msg.sender];
    }

    function protectExternalStore(address signer) external returns (bool) {
        require(msg.sender == address(resourceDropping), 'Unauthorized');
        emit Entered(signer);
        uint256 res = resourceDropping.dropRes();
        emit DroppedRes(res);
        resourceDropping.sink(res);
        res = resourceDropping.dropRes();
        emit DroppedRes(res);
        resourceDropping.sink(res);
        res = resourceDropping.dropRes();
        droppedResources[signer] = Wrapper(res);
        resourceDropping.storeExternal(res);
        return true;
        // try resourceDropping.storeExternalResource(ref) {
        //     droppedResources[signer] = Wrapper(ref);
        //     return true;
        // } catch {
        //     return false;
        // }
    }

    fallback(bytes calldata _in) external returns (bytes memory) {
        emit Fallback(_in);
        callbacks[msg.sender] = _in;
        return _in;
    }

    function wrapResource() public {
        bool res = resourceDropping.protectionLayer(
            address(this),
            abi.encodeCall(this.protectExternalStore, msg.sender)
        );
        if (res) {
            emit Success(true);
        } else {
            emit Fail(true);
        }
    }

    function protectExternalStoreEncoding() public view returns (bytes memory) {
        return abi.encodeCall(this.protectExternalStore, msg.sender);
    }

    function debugEncoding() public {
        emit CbData(abi.encodeCall(this.protectExternalStore, msg.sender));
        emit CbData(abi.encodePacked(this.protectExternalStore, msg.sender));
    }

    function protectionLayerEncoding() public view returns (bytes memory) {
        return
            abi.encodeCall(
                resourceDropping.protectionLayer,
                (
                    address(this),
                    abi.encodeCall(this.protectExternalStore, msg.sender)
                )
            );
    }
}
