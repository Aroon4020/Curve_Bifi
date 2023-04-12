// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/Ownable.sol";
import "../utils/ERC20.sol";
import "../utils/MathLib.sol";
import "../interface/ICurveETH.sol";
import "../interface/IBeefyVault.sol";

contract CurveVault is ERC20, Ownable {
    using SafeERC20 for IERC20;
    using MathLib for uint256;

    event Deposit(uint256[3] amounts, uint256 share, address receiver);

    event Withdraw(uint256[3] amounts, uint256 share, address receiver);

    event WithdrawInSingle(uint256 amount, uint256 share, address receiver);

    ///Curve contract for liquidity
    address public immutable ZAP = 0x3993d34e7e99Abf6B6f367309975d1360222D446;
    ///BEEFY vault to utilize curve farming
    address public immutable BEEFY = 0xe50e2fe90745A8510491F89113959a1EF01AD400;
    /// curve LP
    address public immutable CRV_LP =
        0xc4AD29ba4B3c580e6D59105FFf484999997675Ff;
    /// dev address to tranfer platform fee
    address public DEV_ADD;

    /// USDT,WBTC
    address[2] public tokens = [
        0xdAC17F958D2ee523a2206206994597C13D831ec7,
        0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
    ];

    uint256 PLATFORM_CHARGES;
    uint256 HUNDRED = 100 ether;

    constructor(
        address _devAdd,
        address _owner,
        uint256 _platformCharges,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol, 18) Ownable(_owner) {
        PLATFORM_CHARGES = _platformCharges;
        DEV_ADD = _devAdd;
    }

    receive() external payable {}

    function updateDevAddress(address _devAddress) external onlyOwner {
        DEV_ADD = _devAddress;
    }

    function updatePlatformCharges(uint256 _percent) external onlyOwner {
        require(_percent <= 10 ether, "High Platform Charges");
        PLATFORM_CHARGES = _percent;
    }

    /// @notice deposit any single or all three asset to start earning on assets
    /// @param amounts for WBTC,USDT,ETH
    /// @param receiver share token
    /// @param minAmount minAmount of lp to recieve after liquidity provision
    function deposit(
        uint256[3] memory amounts,
        address receiver,
        uint256 minAmount
    ) external payable {
        require(receiver != address(0), "ZA");
        require(msg.value == amounts[2], "Invalid amount");
        address[2] memory _tokens = tokens;
        for (uint256 i; i < _tokens.length; ) {
            if (amounts[i] > 0) {
                IERC20(_tokens[i]).safeTransferFrom(
                    msg.sender,
                    address(this),
                    amounts[i]
                );
                IERC20(_tokens[i]).safeApprove(ZAP, amounts[i]);
            }
            unchecked {
                ++i;
            }
        }

        uint256 lpAmount = ICurve(ZAP).add_liquidity{value: msg.value}(
            amounts,
            minAmount
        );
        _refundAssets(_tokens[0], _tokens[1]);
        uint256 before = IBeefy(BEEFY).balanceOf(address(this));
        IERC20(CRV_LP).safeApprove(BEEFY, lpAmount);
        IBeefy(BEEFY).deposit(lpAmount);
        uint256 shares = IBeefy(BEEFY).balanceOf(address(this)) - before;
        _mint(receiver, shares);
        emit Deposit(amounts, shares, receiver);
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
        require(receiver != address(0), "ZA");
        address[2] memory token;
        token = tokens;
        _burn(msg.sender, shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount(shares);
        IBeefy(BEEFY).withdraw(userAmount);
        IERC20(BEEFY).safeTransfer(DEV_ADD, devAmount);
        uint256 earned = IERC20(CRV_LP).balanceOf(address(this));
        IERC20(CRV_LP).safeApprove(ZAP, earned);
        uint256[3] memory rcv_amounts = ICurve(ZAP).remove_liquidity(
            earned,
            min_amounts
        );
        for (uint256 i; i <= token.length; ) {
            if (rcv_amounts[i] > 0) {
                if (i == 2) {
                    (bool success, ) = payable(receiver).call{
                        value: rcv_amounts[i]
                    }("");
                    require(success, "TRANSFER_FAILED");
                } else {
                    IERC20(token[i]).safeTransfer(receiver, rcv_amounts[i]);
                }
            }

            unchecked {
                ++i;
            }
        }
        emit Withdraw(rcv_amounts, shares, receiver);
    }

    /// @notice withdraw all amount in any one of three asset acc to the shareAmount
    /// @param shares amount of share token
    /// @param min_amount minimum amount out acc to share
    /// @param index [USDT,WBTC,ETH] of token in amount to be withdrawn
    /// @param receiver tokens receiver
    function withdrawInOne(
        uint256 shares,
        uint256 min_amount,
        uint256 index,
        address receiver
    ) external {
        require(receiver != address(0), "ZA");
        require(index < 3, "Invalid Index");
        _burn(msg.sender, shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount(shares);
        IBeefy(BEEFY).withdraw(userAmount);
        IERC20(BEEFY).safeTransfer(DEV_ADD, devAmount);
        uint256 earned = IERC20(CRV_LP).balanceOf(address(this));
        IERC20(CRV_LP).safeApprove(ZAP, earned);
        uint256 rcv_amount = ICurve(ZAP).remove_liquidity_one_coin(
            earned,
            index,
            min_amount
        );
        if (rcv_amount > 0) {
            if (index == 2) {
                (bool success, ) = payable(receiver).call{value: rcv_amount}(
                    ""
                );
                require(success, "TRANSFER_FAILED");
            } else {
                IERC20(tokens[index]).safeTransfer(receiver, rcv_amount);
            }
        }
        emit WithdrawInSingle(rcv_amount, shares, receiver);
    }

    function _refundAssets(address token0, address token1) internal {
        uint256 amount = address(this).balance;
        if (amount > 0) {
            (bool success, ) = payable(msg.sender).call{value: amount}("");
            require(success, "TRANSFER_FAILED");
        }
        amount = IERC20(token0).balanceOf(address(this));
        if (amount > 0) {
            IERC20(token0).safeTransfer(msg.sender, amount);
        }
        amount = IERC20(token1).balanceOf(address(this));
        if (amount > 0) {
            IERC20(token1).safeTransfer(msg.sender, amount);
        }
    }

    function _calculateAmount(
        uint256 shares
    ) internal view returns (uint256 devAmount, uint256 userAmount) {
        devAmount = (shares * PLATFORM_CHARGES) / HUNDRED;
        userAmount = shares - devAmount;
    }
}
