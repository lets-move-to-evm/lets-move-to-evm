//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

contract CallbackTest {
    // constructor() {
    //     logBytes(hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000024f29fe018000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000000000000000000000000000000000000");
    // }

    event CbData(bytes data);

    function protect1(
        address protected_contract,
        address,
        bytes memory cbdata
    ) external returns (bool) {
        require(protected_contract == msg.sender);
        bool success;
        assembly {
            log0(add(cbdata, 0x20), mload(cbdata))
            success := call(
                gas(),
                caller(),
                0,
                add(cbdata, 0x20),
                mload(cbdata),
                0,
                0
            )
        }
        return success;
    }

    function protect2(bytes memory cbdata) external returns (bool) {
        bool success;
        assembly {
            log0(add(cbdata, 0x20), mload(cbdata))
            success := call(
                gas(),
                caller(),
                0,
                add(cbdata, 0x20),
                mload(cbdata),
                0,
                0
            )
        }
        return success;
    }

    function protect3(bytes memory cbdata) external returns (bool) {
        emit CbData(cbdata);
        (bool success, ) = msg.sender.call(cbdata);
        return success;
    }
}

contract CallbackCaller {
    CallbackTest public callbackTest;

    mapping(address => bytes) public cbdata;

    constructor() {
        callbackTest = new CallbackTest();
    }

    function protectExternalStore(address initiator) external returns (bool) {
        cbdata[initiator] = hex'cafe';
        return true;
    }

    function wrapResource1() public {
        bool res = callbackTest.protect1(
            address(this),
            msg.sender,
            abi.encodeCall(this.protectExternalStore, msg.sender)
        );
        require(res, 'External store protection failed');
    }

    function wrapResource2() public {
        bool res = callbackTest.protect2(
            abi.encodeCall(this.protectExternalStore, msg.sender)
        );
        require(res, 'External store protection failed');
    }
}
