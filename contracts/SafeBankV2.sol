// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeBankV3 {
    mapping(address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 depositedAmount = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;
        payable(msg.sender).call{value: depositedAmount}("");
    }
}
