import { expect } from "chai";
import { ethers } from "hardhat";

export function shouldCreatePoolCorrectly(): void {
  it("should create pool correctly", async function () {
    const numeraire = this.numeraire;
    const backed = this.backed;
    const factory = this.factory;

    await factory.createPool(backed.address, numeraire.address, 1);

    expect(await factory.getPool(backed.address, numeraire.address, 1)).not.to.equal(0);
  });
}

export function shouldSellCorrectly(): void {
  it("should sell correctly", async function () {
    const numInception = ethers.utils.parseUnits("1000.0", 18);
    const backedInception = ethers.utils.parseUnits("1000000.0", 18);
    const numeraire = this.numeraire;
    const backed = this.backed;
    const myBalance = await backed.balanceOf(this.signers.admin.address);
    const toInject = myBalance.sub(backedInception);
    const pool = this.pool;
    const admin = this.signers.admin;

    await numeraire.connect(admin).transfer(pool.address, numInception);
    await backed.connect(admin).transfer(pool.address, toInject);
    await backed.connect(admin).approve(pool.address, backedInception);

    expect(await backed.balanceOf(admin.address)).to.equal(backedInception);

    const initialBalance = await numeraire.balanceOf(admin.address);

    await pool.sell(backedInception.div(10));

    expect(await numeraire.balanceOf(admin.address)).to.equal(initialBalance.add(numInception.div(10)));
  });
}

export function shouldBuyCorrectly(): void {
  it("should buy correctly", async function () {
    const numInception = ethers.utils.parseUnits("1000.0", 18);
    const backedInception = ethers.utils.parseUnits("1000000.0", 18);
    const numeraire = this.numeraire;
    const backed = this.backed;
    const myBalance = await backed.balanceOf(this.signers.admin.address);
    const toInject = myBalance.sub(backedInception);
    const pool = this.pool;
    const admin = this.signers.admin;

    await numeraire.connect(admin).transfer(pool.address, numInception);
    await backed.connect(admin).transfer(pool.address, toInject);
    await numeraire.connect(admin).approve(pool.address, numInception);

    expect(await backed.balanceOf(admin.address)).to.equal(backedInception);

    const initialBalance = await backed.balanceOf(admin.address);

    await pool.buy(numInception.div(10));

    expect(await backed.balanceOf(admin.address)).to.equal(initialBalance.add(backedInception.mul(10).div(101)));
  });
}
