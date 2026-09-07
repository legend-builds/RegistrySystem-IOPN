import { expect } from "chai";
import { ethers } from "hardhat";
import { BuilderRegistry } from "../typechain-types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

describe("BuilderRegistry Contract", function () {
  let builderRegistry: BuilderRegistry;
  let owner: HardhatEthersSigner;
  let addr1: HardhatEthersSigner;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    const BuilderRegistryFactory = await ethers.getContractFactory("BuilderRegistry");
    builderRegistry = await BuilderRegistryFactory.deploy();
  });

  it("Should allow a user to register as a builder", async function () {
    await builderRegistry.connect(addr1).registerBuilder("Aragoorn");
    
    const details = await builderRegistry.getBuilderDetails(addr1.address);
    expect(details.githubUsername).to.equal("Aragoorn");
    expect(details.points).to.equal(100);
    expect(details.isActive).to.be.true;
  });

  it("Should prevent double registration", async function () {
    await builderRegistry.connect(addr1).registerBuilder("Aragoorn");
    await expect(
      builderRegistry.connect(addr1).registerBuilder("AragoornDuplicate")
    ).to.be.revertedWith("Builder already registered");
  });

  it("Should allow owner to award points", async function () {
    await builderRegistry.connect(addr1).registerBuilder("Aragoorn");
    await builderRegistry.awardPoints(addr1.address, 50);

    const details = await builderRegistry.getBuilderDetails(addr1.address);
    expect(details.points).to.equal(150);
  });
});
