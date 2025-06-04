//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

interface IProtectionLayerV2 {
    function storeExternal(uint256) external;
    function unstoreExternal(uint256) external;
    function protectionLayer(address, bytes memory) external returns (bool);
}

interface IBasicNFT is IProtectionLayerV2 {
    function register() external;
    function initToken(string memory, string memory) external;
    function mint(uint64, address) external;
    function transfer(address, uint64) external;
    function approve(address, uint64) external;
    function transferFrom(address, address, uint64) external;
    function withdraw(uint64) external returns (uint256);
    function deposit(address, uint256) external;
    function balanceOf(address) external view returns (uint64);
}

contract BasicNFTTestV1 {
    struct Wrapper {
        uint64 nft;
    }

    IBasicNFT public immutable basicNFT;

    mapping(address => Wrapper) public wrappers;

    constructor(address _basicNFT) {
        basicNFT = IBasicNFT(_basicNFT);
    }

    function initToken(
        address signer,
        string memory name,
        string memory uri
    ) public {
        require(msg.sender == address(basicNFT), 'Unauthorized');
        basicNFT.initToken(name, uri);
    }

    function register(address signer) public {
        require(msg.sender == address(basicNFT), 'Unauthorized');
        basicNFT.register();
    }

    function mint(address signer, uint64 tokenId) public {
        require(msg.sender == address(basicNFT), 'Unauthorized');
        basicNFT.mint(tokenId, signer);
    }

    function withdraw(address signer, uint64 tokenId) public {
        require(msg.sender == address(basicNFT), 'Unauthorized');
        uint256 nft = basicNFT.withdraw(tokenId);
        basicNFT.storeExternal(nft);
    }

    function transfer(address signer, uint64 tokenId, address to) public {
        require(msg.sender == address(basicNFT), 'Unauthorized');
        basicNFT.transfer(to, tokenId);
    }

    function approve(address signer, address to, uint64 tokenId) public {
        require(msg.sender == address(basicNFT), 'Unauthorized');
        basicNFT.approve(to, tokenId);
    }

    function transferFrom(
        address signer,
        address from,
        address to,
        uint64 tokenId
    ) public {
        require(msg.sender == address(basicNFT), 'Unauthorized');
        basicNFT.transferFrom(from, to, tokenId);
    }
}
