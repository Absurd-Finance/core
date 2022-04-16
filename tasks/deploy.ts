import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import { Factory } from "../src/types/Factory";
import { Factory__factory } from "../src/types/factories/Factory__factory";

task("deploy").setAction(async function (taskArguments: TaskArguments, { ethers }) {
  const factoryFactory: Factory__factory = <Factory__factory>await ethers.getContractFactory("Factory");
  const factory: Factory = <Factory>await factoryFactory.deploy();
  await factory.deployed();
  console.log("Factory deployed to: ", factory.address);
});
