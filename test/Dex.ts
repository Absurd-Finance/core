import { artifacts, ethers, waffle } from "hardhat";
import type { Artifact } from "hardhat/types";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import type { Factory } from "../src/types/Factory";
import type { MockToken } from "../src/types/MockToken";
import type { Pool } from "../src/types/Pool";

import { Signers } from "./types";
import { shouldCreatePoolCorrectly, shouldSellCorrectly, shouldBuyCorrectly } from "./Dex.behavior";

describe("Unit tests", function () {
  before(async function () {
    this.signers = {} as Signers;

    const signers: SignerWithAddress[] = await ethers.getSigners();
    this.signers.admin = signers[0];
  });

  describe("Dex basic behaviour", function () {
    beforeEach(async function () {
      const numeraireArtifact: Artifact = await artifacts.readArtifact("MockToken");
      this.numeraire = <MockToken>(
        await waffle.deployContract(this.signers.admin, numeraireArtifact, ["Numeraire", "NUM"])
      );

      const backedArtifact: Artifact = await artifacts.readArtifact("MockToken");
      this.backed = <MockToken>await waffle.deployContract(this.signers.admin, backedArtifact, ["Backed", "BCK"]);

      const factoryArtifact: Artifact = await artifacts.readArtifact("Factory");
      this.factory = <Factory>await waffle.deployContract(this.signers.admin, factoryArtifact, []);

      const poolArtifact: Artifact = await artifacts.readArtifact("Pool");
      this.pool = <Pool>(
        await waffle.deployContract(this.signers.admin, poolArtifact, [
          this.factory.address,
          this.backed.address,
          this.numeraire.address,
          100,
        ])
      );

      await this.numeraire.mint(this.signers.admin.address, ethers.utils.parseUnits("1000000000", 18));
      await this.backed.mint(this.signers.admin.address, ethers.utils.parseUnits("1000000000", 18));
    });

    shouldCreatePoolCorrectly();
    shouldSellCorrectly();
    shouldBuyCorrectly();
  });
});
