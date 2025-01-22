//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IBasicCoin {
    struct Coin {
        uint256 value;
    }
    function deposit(address, Coin memory) external;
    function register() external;
}

contract Challenge4 {
    IBasicCoin public immutable basicCoin;

    constructor(address _basicCoin) {
        basicCoin = IBasicCoin(_basicCoin);
    }

    function forgeResource(uint256 amount) public {
        IBasicCoin.Coin memory coin = IBasicCoin.Coin(amount);
        basicCoin.deposit(address(this), coin);
    }

    function register() public {
        basicCoin.register();
    }
}
