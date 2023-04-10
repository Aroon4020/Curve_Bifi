// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/ERC20.sol";
import "../utils/MathLib.sol";
import "../interface/ICurveETH.sol";
import "../interface/IBeefyVault.sol";

contract CurveVault is ERC20 {
    using SafeERC20 for ERC20;
    using MathLib for uint256;

    event Deposit(uint256[3] amounts,uint256 share,address receiver);

    event Withdraw(uint256[3] amounts,uint256 share,address receiver);

    event WithdrawInSingle(uint256 amount,uint256 share,address receiver);

    ///Curve contract for liquidity
    address public immutable ZAP; /// 0x3993d34e7e99Abf6B6f367309975d1360222D446;
    ///BEEFY vault to utilize curve farming
    address public immutable BEEFY; /// 0xe50e2fe90745A8510491F89113959a1EF01AD400;
    /// curve LP
    address public immutable CRV_LP; /// 0xc4AD29ba4B3c580e6D59105FFf484999997675Ff;
    /// dev address to tranfer platform fee
    address public immutable DEV_ADD; /// 0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97;

    /// USDT,WBTC
    address[2] public tokens; /// 0xdAC17F958D2ee523a2206206994597C13D831ec7, 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599

    uint256 PLATFORM_CHARGES = 2 ether;
    uint256 HUNDRED = 100 ether;

    constructor(
        address[2] memory _tokens,
        address _zap,
        address _beefy,
        address crv_lp,
        address dev_add,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol, 18) {
        tokens = _tokens;
        ZAP = _zap;
        BEEFY = _beefy;
        CRV_LP = crv_lp;
        DEV_ADD = dev_add;
    }

    receive() external payable {}

    /// @notice deposit any single or all three asset to start earning on assets
    /// @param amounts for WBTC,USDT,ETH
    /// @param receiver share token
    /// @param minAmount minAmount of lp to recieve after liquidity provision
    function deposit(
        uint256[3] memory amounts,
        address receiver,
        uint256 minAmount
    ) external payable {
        require(msg.value == amounts[2], "Invalid amount");
        address[2] memory _tokens = tokens;
        bool success;
        for (uint256 i; i < _tokens.length; ) {
            if (amounts[i] > 0) {
                (success, ) = _tokens[i].call(
                    abi.encodeWithSignature(
                        "transferFrom(address,address,uint256)",
                        msg.sender,
                        address(this),
                        amounts[i]
                    )
                );
                require(success, "TRANSFER_FAILED");
                (success, ) = _tokens[i].call(
                    abi.encodeWithSignature(
                        "approve(address,uint256)",
                        ZAP,
                        amounts[i]
                    )
                );
                require(success, "APPROVED_FAILED");
            }
            unchecked {
                i++;
            }

        }

        uint256 lpAmount = ICurve(ZAP).add_liquidity{value: msg.value}(
            amounts,
            minAmount
        );
        _returnAssets(IERC20(_tokens[0]), IERC20(_tokens[1]));
        uint256 before = IBeefy(BEEFY).balanceOf(address(this));
        IERC20(CRV_LP).approve(BEEFY, lpAmount);
        IBeefy(BEEFY).deposit(lpAmount);
        uint256 shares = IBeefy(BEEFY).balanceOf(address(this)) - before;
        _mint(receiver, shares);
        emit Deposit(amounts,shares,receiver);
    }

    /// @notice withdraw all three asset acc to the shareAmount
    /// @param shares amount of share token
    /// @param min_amounts minimum amount for WBTC,USDT,ETH acc to share
    /// @param receiver tokens receiver
    function withdraw(
        uint256 shares,
        uint256[3] memory min_amounts,
        address receiver
    ) external {
        address[2] memory token;
        bool success;
        token = tokens;
        _burn(msg.sender, shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount(shares);
        IBeefy(BEEFY).withdraw(userAmount);
        IERC20(BEEFY).transfer(DEV_ADD, devAmount);
        uint256 earned = IERC20(CRV_LP).balanceOf(address(this));
        IERC20(CRV_LP).approve(ZAP, earned);
        uint256[3] memory rcv_amounts = ICurve(ZAP).remove_liquidity(
            earned,
            min_amounts
        );
        for (uint256 i; i < token.length + 1; ) {
            if (rcv_amounts[i] > 0) {
                if (i == 2) {
                    (success, ) = payable(receiver).call{value: rcv_amounts[i]}(
                        ""
                    );
                    require(success, "TRANSFER_FAILED");
                } else {
                    (success, ) = token[i].call(
                        abi.encodeWithSignature(
                            "transfer(address,uint256)",
                            receiver,
                            rcv_amounts[i]
                        )
                    );
                    require(success, "TRANSFER_FAILED");
                }
            }

            unchecked {
                i++;
            }
        }
        emit Withdraw(rcv_amounts,shares,receiver);
    }

    /// @notice withdraw all amount in any one of three asset acc to the shareAmount
    /// @param shares amount of share token
    /// @param min_amount minimum amount out acc to share
    /// @param index [USDT,WBTC,ETH] of token in amount to be withdrawn
    /// @param receiver tokens receiver
    function withDrawInOne(
        uint256 shares,
        uint256 min_amount,
        uint256 index,
        address receiver
    ) external {
        require(index < 3, "Invalid index");
        _burn(msg.sender, shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount(shares);
        IBeefy(BEEFY).withdraw(userAmount);
        IERC20(BEEFY).transfer(DEV_ADD, devAmount);
        uint256 earned = IERC20(CRV_LP).balanceOf(address(this));
        IERC20(CRV_LP).approve(ZAP, earned);
        uint256 rcv_amount = ICurve(ZAP).remove_liquidity_one_coin(
            earned,
            index,
            min_amount
        );
        bool success;
        if (rcv_amount > 0) {
            if (index == 2) {
                (success, ) = payable(receiver).call{value: rcv_amount}("");
                require(success, "TRANSFER_FAILED");
            } else {
                (success, ) = tokens[index].call(
                    abi.encodeWithSignature(
                        "transfer(address,uint256)",
                        receiver,
                        rcv_amount
                    )
                );
                require(success, "TRANSFER_FAILED");
            }
        }
        emit WithdrawInSingle(rcv_amount,shares,receiver);
    }

    function _returnAssets(IERC20 token0, IERC20 token1) internal {
        bool success;
        uint256 amount = address(this).balance;
        if (amount > 0) {
            (success, ) = payable(msg.sender).call{value: amount}("");
            require(success, "TRANSFER_FAILED");
        }
        amount = IERC20(token0).balanceOf(address(this));
        if (amount > 0) {
            (success, ) = address(token0).call(
                abi.encodeWithSignature(
                    "transfer(address,uint256)",
                    msg.sender,
                    amount
                )
            );
            require(success, "TRANSFER_FAILED");
        }
        amount = IERC20(token1).balanceOf(address(this));
        if (amount > 0) {
            (success, ) = address(token1).call(
                abi.encodeWithSignature(
                    "transfer(address,uint256)",
                    msg.sender,
                    amount
                )
            );
            require(success, "TRANSFER_FAILED");
        }
    }

    function _calculateAmount(uint256 shares)
        internal
        view
        returns (uint256 devAmount, uint256 userAmount)
    {
        devAmount = (shares * PLATFORM_CHARGES) / HUNDRED;
        userAmount = shares - devAmount;
    }
}
