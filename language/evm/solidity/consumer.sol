//SPDX-License-Identifier: MIT

import "./base.sol";

pragma solidity 0.8.22;

contract A {

    CoinWrapper myCoin;

    struct CoinWrapper {
        MoveToEvm.Coin coin;
    }

    function entry(address _moveToEvm) public {
        MoveToEvm(_moveToEvm).externalCall();
    }

    function linearCall() public {
        MoveToEvm.Coin memory c = MoveToEvm(msg.sender).getCoin();
        myCoin = CoinWrapper(c);
    }
}