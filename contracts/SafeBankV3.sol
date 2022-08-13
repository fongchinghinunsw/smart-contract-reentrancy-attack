//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SafeBankV4 is ReentrancyGuard {
    mapping(address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external nonReentrant {
        uint256 depositedAmount = balanceOf[msg.sender];
        payable(msg.sender).call{value: depositedAmount}("");
        balanceOf[msg.sender] = 0;
    }
}

