
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IBeefy{
    function deposit(uint256 amount) external;
    function withdraw(uint256 _shares) external;
    function balanceOf(address account) external returns(uint256);
}