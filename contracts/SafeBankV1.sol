// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SafeBankV1 {
    mapping(address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 depositedAmount = balanceOf[msg.sender];
        console.log("Trying to withdraw", depositedAmount, "ETH");
        // forward a fixed amount of 2300 gas, returns false upon failure
        bool didSend = payable(msg.sender).send(depositedAmount);
        console.log("didSend:", didSend);
        balanceOf[msg.sender] = 0;
    }

    // function withdraw() external {
    //     uint256 depositedAmount = balanceOf[msg.sender];
    //     // forward a fixed amount of 2300 gas, raises an exception if failed
    //     payable(msg.sender).transfer(depositedAmount);
    //     balanceOf[msg.sender] = 0;
    // }

    // function withdraw() external {
    //     uint256 depositedAmount = balanceOf[msg.sender];
    //     // forward a fixed amount of 2300 gas, raises an exception if failed
    //     // same as payable(msg.sender).call({value: depositedAmount, gas: 2300});
    //     payable(msg.sender).call{value: depositedAmount, gas: 2300}("");
    //     balanceOf[msg.sender] = 0;
    // }
}

