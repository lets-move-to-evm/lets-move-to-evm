//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IBasicCoin {
    struct Coin {
        uint256 value;
    }
    function withdraw(uint256) external returns (Coin memory);
    function deposit(address, Coin memory) external;
    function register() external;
}

contract Challenge2 {
    IBasicCoin public immutable basicCoin;

    constructor(address _basicCoin) {
        basicCoin = IBasicCoin(_basicCoin);
    }

    function manipulateResource(
        uint256 initialAmount,
        uint256 finalAmount
    ) public {
        IBasicCoin.Coin memory coin = basicCoin.withdraw(initialAmount);
        coin.value = finalAmount;
        basicCoin.deposit(address(this), coin);
    }

    function register() public {
        basicCoin.register();
    }
}
