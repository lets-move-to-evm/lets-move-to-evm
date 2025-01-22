//SPDX-License-Identifier: MIT

import './MoveToEvm.sol';

pragma solidity >=0.8.11;

contract LinearCall {
    CoinWrapper myCoin;

    struct CoinWrapper {
        MoveToEvm.Coin coin;
    }

    function entry(address _moveToEvm) public {
        MoveToEvm mte = MoveToEvm(_moveToEvm);
        mte.register(address(this));
        mte.externalCall();
    }

    function linearCall() public {
        MoveToEvm.Coin memory c = MoveToEvm(msg.sender).getCoin();
        myCoin = CoinWrapper(c);
    }
}
