// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/ERC20.sol";
import "../utils/MathLib.sol";
import "../interface/ICurveMatic.sol";
import "../interface/IBeefyVault.sol";
import "hardhat/console.sol";

contract CurveMatic is ERC20 {
    using SafeERC20 for ERC20;
    using MathLib for uint256;

    /// Curve factory contract
    address public immutable ZAP; /// 0x3d8EADb739D1Ef95dd53D718e4810721837c69c1;
    /// curve pool address
    address public immutable POOL;
    /// BEEFY vault to utilize curve farming
    address public immutable BEEFY; /// 0x23c65213458A2dcc1321f84Ab42dCaECD79C2215;
    /// curve LP
    address public immutable CRV_LP; ///  0xb0658482b405496C4EE9453cD0a463b134aEf9d0;
    /// dev address to tranfer platform fee
    address public immutable DEV_ADD; /// 0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97;

    /// 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063 DAI
    /// 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174 USDC
    /// 0xc2132D05D31c914a87C6611C10748AEb04B58e8F USDT
    /// 0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6 WBTC
    /// 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619 WETH
    address[5] public tokens;

    uint256 PLATFORM_CHARGES = 2 ether;
    uint256 HUNDRED = 100 ether;

    constructor(
        address[5] memory _tokens,
        address _zap,
        address _pool,
        address _beefy,
        address crv_lp,
        address dev_add,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol, 18) {
        tokens = _tokens;
        ZAP = _zap;
        POOL = _pool;
        BEEFY = _beefy;
        CRV_LP = crv_lp;
        DEV_ADD = dev_add;
    }

    receive() external payable {}

    /// @notice deposit any single or all six asset to start earning on assets
    /// @param amounts for MATIC,DAI,USDC,USDT,WBTC,WETH
    /// @param receiver share token
    /// @param minAmount minAmount of lp to recieve after liquidity provision
    function deposit(
        uint256[6] memory amounts,
        address receiver,
        uint256 minAmount
    ) external payable {
        address[5] memory _tokens = tokens;
        bool success;
        for (uint256 i = 0; i < _tokens.length; ) {
            if (amounts[i + 1] > 0) {
                (success, ) = _tokens[i].call(
                    abi.encodeWithSignature(
                        "transferFrom(address,address,uint256)",
                        msg.sender,
                        address(this),
                        amounts[i + 1]
                    )
                );
                require(success, "TRANSFER_FAILED");
                (success, ) = _tokens[i].call(
                    abi.encodeWithSignature(
                        "approve(address,uint256)",
                        ZAP,
                        amounts[i + 1]
                    )
                );
                require(success, "APPROVED_FAILED");
            }
            unchecked {
                i++;
            }
        }

        uint256 lpAmount = ICurveMatic(ZAP).add_liquidity{value: msg.value}(
            POOL,
            amounts,
            minAmount,
            msg.value > 0 ? true : false
        );
        uint256 before = IBeefy(BEEFY).balanceOf(address(this));
        IERC20(CRV_LP).approve(BEEFY, lpAmount);
        IBeefy(BEEFY).deposit(lpAmount);

        _mint(receiver, IBeefy(BEEFY).balanceOf(address(this)) - before);
        _returnAssets();
    }

    /// @notice withdraw all six asset acc to the shareAmount
    /// @param shares amount of share token
    /// @param min_amounts minimum amount for MATIC,DAI,USDC,USDT,WBTC,WETH acc to share
    /// @param receiver tokens receiver
    function withdraw(
        uint256 shares,
        uint256[6] memory min_amounts,
        address receiver
    ) external {
        address[5] memory _tokens;
        bool success;
        _tokens = tokens;
        _burn(msg.sender, shares);
        IBeefy(BEEFY).withdraw(shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount();
        IERC20(CRV_LP).approve(ZAP, userAmount);
        uint256[6] memory rcv_amounts = ICurveMatic(ZAP).remove_liquidity(
            POOL,
            userAmount,
            min_amounts,
            true
        );
        IERC20(CRV_LP).transfer(DEV_ADD, devAmount);

        for (uint256 i; i < _tokens.length; ) {
            if (rcv_amounts[i] > 0) {
                if (i == 0) {
                    (success, ) = payable(receiver).call{value: rcv_amounts[i]}(
                        ""
                    );
                    require(success, "TRANSFER_FAILED");
                }
                (success, ) = _tokens[i].call(
                    abi.encodeWithSignature(
                        "transfer(address,uint256)",
                        receiver,
                        rcv_amounts[i + 1]
                    )
                );
                require(success, "TRANSFER_FAILED");
            }
            unchecked {
                i++;
            }
        }
    }

    /// @notice withdraw all amount in any one of six asset acc to the shareAmount
    /// @param shares amount of share token
    /// @param min_amount minimum amount out acc to share
    ///  @param index [MATIC,DAI,USDC,USDT,WBTC,WETH] of token in amount to be withdrawn
    /// @param receiver tokens receiver
    function withDrawInOne(
        uint256 shares,
        uint256 min_amount,
        uint256 index,
        address receiver
    ) external {
        require(index < 6, "Invalid index");
        _burn(msg.sender, shares);
        IBeefy(BEEFY).withdraw(shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount();
        IERC20(CRV_LP).approve(ZAP, userAmount);
        uint256 rcv_amount = ICurveMatic(ZAP).remove_liquidity_one_coin(
            POOL,
            userAmount,
            index,
            min_amount,
            index == 0 ? true : false
        );
        IERC20(CRV_LP).transfer(DEV_ADD, devAmount);
        bool success;
        if (rcv_amount > 0) {
            if (index == 0) {
                (success, ) = payable(receiver).call{value: rcv_amount}("");
                require(success, "TRANSFER_FAILED");
            } else {
                (success, ) = tokens[index - 1].call(
                    abi.encodeWithSignature(
                        "transfer(address,uint256)",
                        receiver,
                        rcv_amount
                    )
                );
                require(success, "TRANSFER_FAILED");
            }
        }
    }

    function _calculateAmount()
        internal
        view
        returns (uint256 devAmount, uint256 userAmount)
    {
        uint256 amount = IERC20(CRV_LP).balanceOf(address(this));
        devAmount = (amount * PLATFORM_CHARGES) / HUNDRED;
        userAmount = amount - devAmount;
    }

    function _returnAssets() internal {
        address[5] memory _tokens = tokens;
        bool success;

        uint256 amount = address(this).balance;
        if (amount > 0) {
            (success, ) = payable(msg.sender).call{value: amount}("");
            require(success, "TRANSFER_FAILED");
        }
        for (uint256 i; i < _tokens.length; ) {
            amount = IERC20(_tokens[i]).balanceOf(address(this));
            if (amount > 0) {
                (success, ) = _tokens[i].call(
                    abi.encodeWithSignature(
                        "transfer(address,uint256)",
                        msg.sender,
                        amount
                    )
                );
                require(success, "TRANSFER_FAILED");
            }
            unchecked {
                i++;
            }
        }
    }
}
