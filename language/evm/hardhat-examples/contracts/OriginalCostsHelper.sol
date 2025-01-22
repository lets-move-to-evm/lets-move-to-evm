//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IOriginalCostsHelper {
    struct S {
        uint256 val;
    }
    function doNothing() external;
    function write(uint256 value) external;
    function read() external returns (uint256);
    function edit(uint256, address) external;
    function get() external returns (S memory);
    function put(S calldata) external;
    function remove() external returns (S memory);
    function sink(S calldata) external;
}

contract OriginalCostsHelper {
    struct Wrapper {
        IOriginalCostsHelper.S s;
    }
    event Log(uint256 s);

    IOriginalCostsHelper public immutable originalCostsHelper;

    mapping(address => Wrapper) public wrappers;

    constructor(address _originalCostsHelper) {
        originalCostsHelper = IOriginalCostsHelper(_originalCostsHelper);
    }

    function write(uint256 value) public {
        originalCostsHelper.write(value);
    }

    function read() public {
        originalCostsHelper.read();
    }

    function edit(uint256 value) public {
        originalCostsHelper.edit(value, address(this));
    }

    function get() public {
        originalCostsHelper.get();
    }

    function put() public {
        IOriginalCostsHelper.S memory s = IOriginalCostsHelper.S(0);
        originalCostsHelper.put(s);
    }

    function writeAndEdit() public {
        originalCostsHelper.write(14);
        originalCostsHelper.edit(44, address(this));
    }

    function getAndPut() public {
        IOriginalCostsHelper.S memory s = originalCostsHelper.get();
        originalCostsHelper.put(s);
    }

    function getAndSink() public {
        IOriginalCostsHelper.S memory s = originalCostsHelper.get();
        originalCostsHelper.sink(s);
    }

    function getAndStoreExternal() public {
        IOriginalCostsHelper.S memory s = originalCostsHelper.get();
        wrappers[msg.sender] = Wrapper(s);
    }

    function remove() public {
        originalCostsHelper.remove();
    }

    function sink() public {
        IOriginalCostsHelper.S memory s = IOriginalCostsHelper.S(0);
        originalCostsHelper.sink(s);
    }

    /********** Encoding functions for testing **********/

    // function withdrawEncoding(
    //     uint256 amount
    // ) public view returns (bytes memory) {
    //     return abi.encodeCall(this.withdraw, (msg.sender, amount));
    // }

    // function mintToEncoding(
    //     uint256 amount,
    //     address to
    // ) public view returns (bytes memory) {
    //     return abi.encodeCall(this.mintTo, (msg.sender, amount, to));
    // }

    // function depositEncoding() public view returns (bytes memory) {
    //     return abi.encodeCall(this.deposit, msg.sender);
    // }

    // function transferEncoding(
    //     uint256 amount,
    //     address to
    // ) public view returns (bytes memory) {
    //     return abi.encodeCall(this.transfer, (msg.sender, amount, to));
    // }

    // function doNothingEncoding() public view returns (bytes memory) {
    //     return abi.encodeCall(this.doNothing, ());
    // }
}
