import { ethers } from "hardhat";

async function main(): Promise<void> {
  const BuilderRegistry = await ethers.getContractFactory("BuilderRegistry");
  console.log("Deploying BuilderRegistry with TypeScript...");
  
  const builderRegistry = await BuilderRegistry.deploy();
  await builderRegistry.waitForDeployment();

  const address: string = await builderRegistry.getAddress();
  console.log(`BuilderRegistry deployed to: ${address}`);
}

main().catch((error: Error) => {
  console.error(error);
  process.exitCode = 1;
});