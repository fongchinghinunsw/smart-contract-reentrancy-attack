// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 depositedAmount = balanceOf[msg.sender];
        // same as payable(msg.sender).call({value: depositedAmount});
        payable(msg.sender).call{value: depositedAmount}("");
        balanceOf[msg.sender] = 0;
    }
}
