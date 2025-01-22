//SPDX-License-Identifier: MIT

/**
    TODO:
    - IMPORTANT how can we check it the resource has been accessed/modified?
    - Maybe we could use a library to define Move Semantics, a Base contract with the linearity check 
      and then contracts inherits this Base contract
    - Can we borrow a Coin resource and then borrow another Coin resource during a single transaction?
    - Can we borrow a Coin resource and then borrow the same Coin resource during a single transaction?
    - Can we move_from a Coin resource and then move_from the same Coin resource during a single transaction?
 */

/**
    * @title MoveToEvm
    * @dev The MoveToEvm contract is a test contract that allows to move resources from one contract to another
    * and check if the contract is linear
*/

/**
    * @dev The ILinear interface is used to check if the contract is linear
    * and to call the linearCall function
 */
pragma solidity 0.8.22;

interface ILinear {
    function linearCall() external;
}

contract MoveToEvm {
    
    mapping (address => Coin) public resources;
    mapping (address => Coin) public externalResources;
    mapping (address => Coin) public temp;

    bool linearity = false;
    uint tempLenght = 0;

    address private owner;

    // RESOURCES STRUCTS
    struct Resource {
        bool exists;
        bool isBorrowed; // necessary?
        bool hasKey;
        bool hasStore;
        bool hasDrop;
        bool hasCopy;
    }

    struct Reference {
        bool isMutable;
    }

    // TEST Resource with has key ONLY
    struct CoinRef {
        Coin res;
        Reference ref;
    }

    struct Coin {
        Resource res;
        uint256 value;
    }

    modifier isLinear() {
        require(linearity == true, "Contract is not linear");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // LINEAR ENTRY POINT
    function externalCall() public {
        linearity = true;
        ILinear c = ILinear(msg.sender);
        c.linearCall();
        linearity = false;
        linearityCheck();
    }

    function getCoin() public isLinear returns (Coin memory) {
        Coin memory s = moveFrom(msg.sender);
        // require(s.res.hasStore == true, "Resource does not have store");
        temp[msg.sender] = s;
        return s;
    }

    function setCoin(Coin memory _value) public isLinear {
        require(temp[msg.sender].value == _value.value, "Resource does not exist");
        moveTo(msg.sender, _value);
    }

    function linearityCheck() private view {
        assert(temp[msg.sender].res.exists != false);
    }

    function mint() onlyOwner public {
        moveTo(msg.sender, createCoin(100));
    }

    function register(address addr) public {
        moveTo(addr, emptyResource());
    }

    function transfer() public {
        Coin memory s = moveFrom(msg.sender);
        moveTo(owner, s);
    }

    // HELPER FUNCTIONS
    function createCoin(uint val) private pure returns (Coin memory) {
        return Coin(Resource(false, false, false, false, false, false), val);
    }

    function emptyResource() private pure returns (Coin memory) {
        return Coin(Resource(false, false, false, false, false, false), 0);
    }

    // MOVE NATIVE FUNCTIONS
    function moveTo(address addr, Coin memory _value) private {
        require(resources[addr].res.exists != true, "Resource already exists");
        _value.res.exists = true;
        resources[addr] = _value;
    }

    function moveFrom(address addr) private returns (Coin memory) {
        require(resources[addr].res.exists == true, "Resource does not exist");
        require(resources[addr].res.isBorrowed == false, "Resource is borrowed");
        Coin memory s = resources[addr];
        resources[addr] = emptyResource();
        return s;
    }

    /*
    function borrow_mut(address addr) private returns (CoinRef memory) {
        require(resources[addr].res.exists == true, "Resource does not exist");
        Coin memory s = resources[addr];
        s.res.isBorrowed = true;
        return s;
    }

    function borrow(address addr) private returns (CoinRef memory) {
        require(resources[addr].res.exists == true, "Resource does not exist");
        Coin memory s = resources[addr];
        return s;
    }
    */
    
} 