// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ICurveMatic {
    // function remove_liquidity_one_coin(uint256 token_amount, uint256 i, uint256 min_amount) external returns(uint256);
    // function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external payable returns(uint256);
    // function remove_liquidity(uint256 _amount,  uint256[3] memory min_amounts) external returns(uint256 [3] memory);


    //function add_liquidity(uint256[5] memory amounts, uint256 min_mint_amount) external payable;
    function remove_liquidity_one_coin(address pool,uint256 token_amount, uint256 i, uint256 min_amount,bool useETH) external returns(uint256);
    function remove_liquidity(address pool,uint256 amount,uint256[6] memory min_amounts,bool useETH) external returns (uint256 [6] memory);
    function add_liquidity(
    address pool,
    uint256[6] memory deposit_amounts,
    uint256 min_mint_amount ,
    bool useEth
) external payable returns(uint256);

//     def remove_liquidity(
//     _pool: address,
//     _burn_amount: uint256,
//     _min_amounts: uint256[N_ALL_COINS],
//     _use_eth: bool = False,
//     _receiver: address = msg.sender,
// ) -> uint256[N_ALL_COINS]:


// def add_liquidity(
//     _pool: address,
//     _deposit_amounts: uint256[N_ALL_COINS],
//     _min_mint_amount: uint256,
//     _use_eth: bool = False,
//     _receiver: address = msg.sender,
// ) -> uint256:


// @external
// def remove_liquidity_one_coin(
//     _pool: address,
//     _burn_amount: uint256,
//     i: uint256,
//     _min_amount: uint256,
//     _use_eth: bool = False,
//     _receiver: address=msg.sender
// ) -> uint256:
}