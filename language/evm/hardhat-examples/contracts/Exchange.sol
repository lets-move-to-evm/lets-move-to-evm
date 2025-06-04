//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Exchange {
    function getExchangeRate() public pure returns (uint256) {
        // Simulate fetching exchange rate from an oracle or external source
        return 1000; // Example exchange rate
    }
}
