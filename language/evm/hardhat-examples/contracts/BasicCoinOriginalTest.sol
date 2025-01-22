//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
}

interface IBasicCoin is IProtectionLayerV2 {
    function register() external;
    function transfer(address, uint256) external;
    function mint(uint256) external returns (uint256);
    function getBalance(address) external view returns (uint256);
    function withdraw(uint256) external returns (uint256);
    function deposit(address, uint256) external;
    function coinValue(uint256) external view returns (uint256);
}

contract BasicCoinOriginalTestV1 {
    struct Wrapper {
        uint256 coin;
    }

    event CbData(bytes data);
    event Entered(address signer);
    event Success(bool success);
    event Fail(bool success);
    event Fallback(bytes data);
    event Coin(uint256 value);
    event Balance(uint256 value);
    event Value(uint256 value);

    IBasicCoin public immutable basicCoin;

    mapping(address => Wrapper) public wrappers;

    constructor(address _basicCoin) {
        basicCoin = IBasicCoin(_basicCoin);
    }

    function register(address signer) public {
        // require(msg.sender == address(basicCoin), 'Unauthorized');
        // emit Entered(signer);
        basicCoin.register();
        // uint256 bal = basicCoin.getBalance(signer);
        // emit Balance(bal);
    }

    function mint(address signer, uint256 amount) public {
        require(msg.sender == address(basicCoin), 'Unauthorized');
        // emit Entered(signer);
        uint256 coin = basicCoin.mint(amount);
        // emit Coin(coin);
        basicCoin.storeExternal(coin);
    }

    function mintTo(address signer, uint256 amount, address to) public {
        require(msg.sender == address(basicCoin), 'Unauthorized');
        // emit Entered(signer);
        uint256 coin = basicCoin.mint(amount);
        // uint256 value = basicCoin.coinValue(coin);
        // require(value == amount, 'Value mismatch');
        // emit Value(value);
        // uint256 balance = basicCoin.getBalance(to);
        // emit Balance(balance);
        basicCoin.deposit(to, coin);
        // balance = basicCoin.getBalance(to);
        // emit Balance(balance);
    }

    function withdraw(address signer, uint256 amount) public {
        require(msg.sender == address(basicCoin), 'Unauthorized');
        // emit Entered(signer);
        uint256 coin = basicCoin.withdraw(amount);
        // emit Coin(coin);
        // uint256 value = basicCoin.coinValue(coin);
        // require(value == amount, 'Value mismatch');
        // emit Value(value);
        basicCoin.storeExternal(coin);
        wrappers[signer] = Wrapper(coin);
    }

    function deposit(address signer) public {
        require(msg.sender == address(basicCoin), 'Unauthorized');
        // emit Entered(signer);
        Wrapper memory wrapper = wrappers[signer];
        // emit Coin(wrapper.coin);
        basicCoin.unstoreExternal(wrapper.coin);
        basicCoin.deposit(signer, wrapper.coin);
    }

    function transfer(address signer, uint256 amount, address to) public {
        // require(msg.sender == address(basicCoin), 'Unauthorized');
        // emit Entered(signer);
        basicCoin.transfer(to, amount);
    }

    function withdrawAndDeposit(
        address signer,
        uint256 amount,
        address to
    ) public {
        require(msg.sender == address(basicCoin), 'Unauthorized');
        // emit Entered(signer);
        uint256 coin = basicCoin.withdraw(amount);
        // emit Coin(coin);
        basicCoin.deposit(to, coin);
    }

    /********** Encoding functions for testing **********/

    function registerEncoding() public view returns (bytes memory) {
        return abi.encodeCall(this.register, msg.sender);
    }

    function withdrawEncoding(
        uint256 amount
    ) public view returns (bytes memory) {
        return abi.encodeCall(this.withdraw, (msg.sender, amount));
    }

    function mintToEncoding(
        uint256 amount,
        address to
    ) public view returns (bytes memory) {
        return abi.encodeCall(this.mintTo, (msg.sender, amount, to));
    }

    function depositEncoding() public view returns (bytes memory) {
        return abi.encodeCall(this.deposit, msg.sender);
    }

    function transferEncoding(
        uint256 amount,
        address to
    ) public view returns (bytes memory) {
        return abi.encodeCall(this.transfer, (msg.sender, amount, to));
    }
}
