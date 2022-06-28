// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeBankV2 {
    mapping(address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 depositedAmount = balanceOf[msg.sender];
        // forward a fixed amount of 2300 gas, raises an exception if failed
        payable(msg.sender).transfer(depositedAmount);
        balanceOf[msg.sender] = 0;
    }
}
