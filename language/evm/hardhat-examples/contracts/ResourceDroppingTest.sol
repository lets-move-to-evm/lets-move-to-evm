//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    struct DroppedRes {
        uint256 val1;
        uint256 val2;
    }
    function protect(address, bytes memory) external returns (bool);
    function dropRes() external returns (DroppedRes memory);
    function sink(DroppedRes memory) external;
    function storeExternalResource(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
}

contract ResourceDroppingTest {
    struct Wrapper {
        IProtectionLayerV2.DroppedRes droppedRes;
    }

    event CbData(bytes data);
    event Entered(address signer);
    event Success(bool success);
    event Fail(bool success);
    event Fallback(bytes data);
    event DroppedRes(IProtectionLayerV2.DroppedRes res);

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

    function createWrapper() public pure returns (Wrapper memory) {
        return Wrapper(IProtectionLayerV2.DroppedRes(14, 44));
    }

    function createResource()
        public
        pure
        returns (IProtectionLayerV2.DroppedRes memory)
    {
        return IProtectionLayerV2.DroppedRes(14, 44);
    }

    function protectExternalStore(address signer) external returns (bool) {
        require(msg.sender == address(resourceDropping), 'Unauthorized');
        emit Entered(signer);
        IProtectionLayerV2.DroppedRes memory res = resourceDropping.dropRes();
        emit DroppedRes(res);
        resourceDropping.sink(res);
        droppedResources[signer] = Wrapper(res);
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
