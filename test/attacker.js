const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test Re-entrancy Attack", function () {
  let deployer, user, attacker;

  beforeEach(async function () {
    [deployer, user, attacker] = await ethers.getSigners();

    // get the factory for creating Bank contract instances
    const BankFactory = await ethers.getContractFactory("Bank", deployer);
    this.bankContract = await BankFactory.deploy();

    // deposit 100 ethers from the deployer account
    await this.bankContract.deposit({ value: ethers.utils.parseEther("100") });
    // deposit 50 ethers from the user account
    await this.bankContract
      .connect(user)
      .deposit({ value: ethers.utils.parseEther("50") });

    // get the factory for creating Attacker contract instances
    const AttackerFactory = await ethers.getContractFactory(
      "Attacker",
      attacker
    );
    this.attackerContract = await AttackerFactory.deploy(
      this.bankContract.address
    );
  });

  describe("Test deposit and withdraw of Bank contract", function () {
    it("Should accept deposits", async function () {
      const deployerBalance = await this.bankContract.balanceOf(
        deployer.address
      );
      // deployer should have 100 ETH
      expect(deployerBalance).to.eq(ethers.utils.parseEther("100"));
      // user should have 50 ETH
      const userBalance = await this.bankContract.balanceOf(user.address);
      expect(userBalance).to.eq(ethers.utils.parseEther("50"));
    });

    it("Should accept withdrawals", async function () {
      await this.bankContract.withdraw();

      const deployerBalance = await this.bankContract.balanceOf(
        deployer.address
      );
      const userBalance = await this.bankContract.balanceOf(user.address);
      // deployer should have 100 ETH after withdrawl
      expect(deployerBalance).to.eq(0);
      expect(userBalance).to.eq(ethers.utils.parseEther("50"));
    });

    it("Perform Attack", async function () {
      console.log("");
      console.log("*** Before ***");
      console.log(
        `Bank's balance: ${ethers.utils
          .formatEther(
            await ethers.provider.getBalance(this.bankContract.address)
          )
          .toString()}`
      );
      console.log(
        `Attacker's balance: ${ethers.utils
          .formatEther(await ethers.provider.getBalance(attacker.address))
          .toString()}`
      );

      await this.attackerContract.attack({
        value: ethers.utils.parseEther("10"),
      });

      console.log("");
      console.log("*** After ***");
      console.log(
        `Bank's balance: ${ethers.utils
          .formatEther(
            await ethers.provider.getBalance(this.bankContract.address)
          )
          .toString()}`
      );
      console.log(
        `Attackers's balance: ${ethers.utils
          .formatEther(await ethers.provider.getBalance(attacker.address))
          .toString()}`
      );
      console.log("");

      expect(await ethers.provider.getBalance(this.bankContract.address)).to.eq(
        0
      );
    });
  });
});
