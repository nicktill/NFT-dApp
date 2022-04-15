const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyNFT", function () {
  it("Should mint and transfer an NFT to someone", async function () {
    const NFTMint = await ethers.getContractFactory("NFTMint");
    const nftMint = await NFTMint.deploy();
    await nftMint.deployed();

    const recipient = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266';
    const metadataURI = 'cid/test.png';

    let balance = await nftMint.balanceOf(recipient);
    expect(balance).to.equal(0);

    const newlyMintedToken = await nftMint.payToMint(recipient, metadataURI, { value: ethers.utils.parseEther('0.05') });

    // wait until the transaction is mined
    await newlyMintedToken.wait();

    balance = await nftMint.balanceOf(recipient)
    expect(balance).to.equal(1);

    expect(await nftMint.isContentOwned(metadataURI)).to.equal(true);
    const newlyMintedToken2 = await nftMint.payToMint(recipient, 'foo', { value: ethers.utils.parseEther('0.05') });
  });
});