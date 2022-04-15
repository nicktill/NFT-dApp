# What is a Non-Fungible Token?

A Non-Fungible Token (NFT) is used to identify something or someone in a unique way. This type of Token is perfect to be used on platforms that offer collectible items, access keys, lottery tickets, numbered seats for concerts and sports matches, etc. This special type of Token has amazing possibilities so it deserves a proper Standard, the ERC-721 came to solve that!

# What is ERC-721?

The ERC-721 introduces a standard for NFT, in other words, this type of Token is unique and can have different value than another Token from the same Smart Contract, maybe due to its age, rarity or even something else like its visual. Wait, visual?

# What is the goal of this repo?

This project explores into web3 technologies, more specifically NFTs and the ERC-721 network they are built on. Utilizing solidity contracts, we are able to create a peer to peer IPFS exchange of NFTs through the ERC-721 token standard built on the Blockchain. Users are able to send requests to mint a one of one non-fungible token, set at a specific ETH price. By stimulating a side chain on the Blockchain using ERC-721 token standards, we are able to stimualtle the actual transactional process on the Blockchain. We link a uid address recipient with a metadataURI IPFS if and only if the requested transaction meets our ETH floor price, and ifso the transaction will generate a one of one NFT and in exchange accept the ETH onto the smart contract.

```
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
        return existingURIs[uri] == 1;
    }
}
```

# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
node scripts/deploy.js
npx eslint '**/*.js'
npx eslint '**/*.js' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.js
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
# Usage
```
git clone <this-repo>
npm install

# terminal 1
npx hardhat node

# terminal 2
npx hardhat compile
npx hardhat run scripts/sample-script.js --network localhost

# terminal 3 
npm run dev
```

