//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
    function dropRes(uint256) external;
}

interface INav is IProtectionLayerV2 {
    function newWithdrawEvent(
        address,
        uint256,
        uint256
    ) external returns (uint256);
    function newSetReferrerEvent(
        string memory,
        address,
        uint256
    ) external returns (uint256);
    function newSetMintPriceEvent(uint256, uint256) external returns (uint256);
}

contract AliensEventsTest {
    INav public immutable nav;

    constructor(address _nav) {
        nav = INav(_nav);
    }

    function newWithdrawEventTest(address signer) public {
        require(msg.sender == address(nav), 'Unauthorized');
        uint256 withdrawEvent = nav.newWithdrawEvent(address(this), 0, 0);
        nav.dropRes(withdrawEvent);
    }

    function newSetReferrerEventTest(address signer) public {
        require(msg.sender == address(nav), 'Unauthorized');
        uint256 setReferrerEvent = nav.newSetReferrerEvent(
            'ciao',
            address(this),
            0
        );
        nav.dropRes(setReferrerEvent);
    }

    function newSetMintPriceEventTest(address signer) public {
        require(msg.sender == address(nav), 'Unauthorized');
        uint256 setMintPriceEvent = nav.newSetMintPriceEvent(0, 0);
        nav.dropRes(setMintPriceEvent);
    }
}
