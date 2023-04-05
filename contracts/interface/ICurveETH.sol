// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ICurve {
    function remove_liquidity_one_coin(uint256 token_amount, uint256 i, uint256 min_amount) external returns(uint256);
    function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external payable returns(uint256);
    function remove_liquidity(uint256 _amount,  uint256[3] memory min_amounts) external returns(uint256 [3] memory);
}

