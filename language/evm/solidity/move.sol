//SPDX-License-Identifier: MIT

library Move {

    mapping (address => Coin) public resources;
    mapping (address => Coin) public externalResources;
    mapping (address => Coin) public temp;

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
    
    // MOVE NATIVE FUNCTIONS
    function moveTo(address addr, Coin memory _value) private {
        require(resources[addr].res.exists != true, "Resource already exists");
        _value.res.exists = true;
        resources[addr] = _value;
    }

    function moveFrom(address addr) private returns (Coin memory) {
        require(resources[addr].res.exists == true, "Resource does not exist");
        Coin memory s = resources[addr];
        resources[addr] = emptyResource();
        return s;
    }

    function borrow_mut(address addr) private returns (CoinRef memory) {
        require(resources[addr].res.exists == true, "Resource does not exist");
        Coin memory s = resources[addr];
        return s;
    }

    function borrow(address addr) private returns (CoinRef memory) {
        require(resources[addr].res.exists == true, "Resource does not exist");
        Coin memory s = resources[addr];
        return s;
    }
}