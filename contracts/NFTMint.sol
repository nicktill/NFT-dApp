// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMint is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    mapping(string => uint8) existingURIs;

    constructor() ERC721("NFTMint", "NFT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    // safe hazard that allows only owners to mint NFT
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // adding functionality so that anyone who completed payment onto smart contract can then Mint
    // first we check to see if the URI has already been minted using require keyword
    //require behaves as a while loop and essentially says if: (this condition not met): do not run function, else: run function
    function payToMint(
        address recipient,
        string memory metadataURI
    ) public payable returns (uint256) {
        require(existingURIs[metadataURI] != 1, 'NFT Already Minted!'); //if URI is 1 (true) that means already minted
        // example ammount of ether, can create fake network side chains on Ethereum to stimulate the actual 
        // process behind crypto transactions on the blockchain and ways to verify user
        // msg.value is a global variable among solidity contracts that allows us to know the value of ETH the receipient user is sending
        require (msg.value >= 0.05 ether, 'Less than minimum Ether detected, add more!');
         // at this point the transaction is not less than floor so we generate the NFT
        uint256 newItemId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        existingURIs[metadataURI] = 1; 
        // set URI to true to essentially say we generated the unique one of one NFT

        _mint(recipient, newItemId);
        _setTokenURI(newItemId, metadataURI);

        return newItemId; 
    }

}
    function count() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function isContentOwned(string memory uri) public view returns (bool) {
        return existingURIs[uri] == 1; //means someone owns this nft already
    }
}
