// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IReentrantContract {
    function reentrant_function() external;
}

contract AttackerV1 {

    constructor ( ) {}

    function attack() public {
        IReentrantContract(msg.sender).reentrant_function();
    }
}