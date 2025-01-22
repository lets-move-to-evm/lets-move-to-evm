//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IBasicCoin {
    struct Coin {
        uint256 value;
    }
    function withdraw(uint256) external returns (Coin memory);
    function register() external;
}

contract Challenge1 {
    IBasicCoin public immutable basicCoin;

    constructor(address _basicCoin) {
        basicCoin = IBasicCoin(_basicCoin);
    }

    function dropResource() public {
        IBasicCoin.Coin memory coin = basicCoin.withdraw(10);
    }

    function register() public {
        basicCoin.register();
    }
}
