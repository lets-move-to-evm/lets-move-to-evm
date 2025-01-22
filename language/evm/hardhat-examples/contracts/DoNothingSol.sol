//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

contract DoNothingSol {
    constructor() {}

    function doNothing() public {}
}

contract Forwarder {
    DoNothingSol public target;

    constructor(address _target) {
        target = DoNothingSol(_target);
    }

    function forward() public {
        target.doNothing();
    }
}
