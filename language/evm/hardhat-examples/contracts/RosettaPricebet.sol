// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

import './Exchange.sol';

contract RosettaPriceBet {
    uint256 initial_pot;
    uint256 deadline_block;
    uint256 exchange_rate;
    address oracle;
    address payable owner;
    address payable player;

    constructor(
        address _oracle,
        uint256 _deadline,
        uint256 _exchange_rate
    ) payable {
        initial_pot = msg.value;
        owner = payable(msg.sender);
        oracle = _oracle;
        deadline_block = block.number + _deadline;
        exchange_rate = _exchange_rate;
    }

    function join() public payable {
        require(msg.value == initial_pot);
        require(player == address(0));
        player = payable(msg.sender);
    }

    function win() public {
        Exchange TheOracle = Exchange(oracle);
        require(block.number < deadline_block, 'deadline expired');
        require(msg.sender == player, 'invalid sender');
        require(
            TheOracle.getExchangeRate() >= exchange_rate,
            'you lost the bet'
        );
        (bool success, ) = player.call{ value: address(this).balance }('');
        require(success, 'Transfer failed.');
    }

    function timeout() public {
        require(block.number >= deadline_block, 'deadline not expired');
        (bool success, ) = owner.call{ value: address(this).balance }('');
        require(success, 'Transfer failed.');
    }
}
