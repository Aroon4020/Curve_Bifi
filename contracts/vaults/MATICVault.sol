// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/Ownable.sol";
import "../utils/ERC20.sol";
import "../utils/MathLib.sol";
import "../interface/ICurveMatic.sol";
import "../interface/IBeefyVault.sol";

contract CurveMatic is ERC20, Ownable {
    using SafeERC20 for IERC20;
    using MathLib for uint256;

    event Deposit(uint256[6] amounts, uint256 share, address receiver);

    event Withdraw(uint256[6] amounts, uint256 share, address receiver);

    event WithdrawInSingle(uint256 amount, uint256 share, address receiver);

    /// Curve factory contract
    address public immutable ZAP = 0x3d8EADb739D1Ef95dd53D718e4810721837c69c1;
    /// curve pool address
    address public immutable POOL = 0x7BBc0e92505B485aeb3e82E828cb505DAf1E50c6;
    /// BEEFY vault to utilize curve farming
    address public immutable BEEFY = 0x23c65213458A2dcc1321f84Ab42dCaECD79C2215;
    /// curve LP
    address public immutable CRV_LP =
        0xb0658482b405496C4EE9453cD0a463b134aEf9d0;
    /// 0x0000000000000000000000000000000000000000 MATIC
    /// 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063 DAI
    /// 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174 USDC
    /// 0xc2132D05D31c914a87C6611C10748AEb04B58e8F USDT
    /// 0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6 WBTC
    /// 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619 WETH
    address[6] public tokens = [
        0x0000000000000000000000000000000000000000,
        0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063,
        0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174,
        0xc2132D05D31c914a87C6611C10748AEb04B58e8F,
        0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6,
        0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619
    ];

    uint256 HUNDRED = 100 ether;

    uint256 PLATFORM_CHARGES;
    /// dev address to tranfer platform fee
    address public DEV_ADD;

    constructor(
        address _devAdd,
        address _owner,
        uint256 _platformCharges,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol, 18) Ownable(_owner) {
        DEV_ADD = _devAdd;
        PLATFORM_CHARGES = _platformCharges;
    }

    receive() external payable {}

    function updateDevAddress(address _devAddress) external onlyOwner {
        DEV_ADD = _devAddress;
    }

    function updatePlatformCharges(uint256 _percent) external onlyOwner {
        require(_percent <= 10 ether, "High Platform Charges");
        PLATFORM_CHARGES = _percent;
    }

    /// @notice deposit any single or all six asset to start earning on assets
    /// @param amounts for MATIC,DAI,USDC,USDT,WBTC,WETH
    /// @param receiver share token
    /// @param minAmount minAmount of lp to recieve after liquidity provision
    function deposit(
        uint256[6] memory amounts,
        address receiver,
        uint256 minAmount
    ) external payable {
        require(receiver != address(0), "ZA");
        require(amounts[0] == msg.value, "Invalid Amount");
        address[6] memory _tokens = tokens;
        for (uint256 i = 1; i < _tokens.length; ) {
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
        uint256 lpAmount = ICurveMatic(ZAP).add_liquidity{value: msg.value}(
            POOL,
            amounts,
            minAmount,
            msg.value > 0 ? true : false
        );
        uint256 before = IBeefy(BEEFY).balanceOf(address(this));
        IERC20(CRV_LP).safeApprove(BEEFY, lpAmount);
        IBeefy(BEEFY).deposit(lpAmount);
        uint256 shares = IBeefy(BEEFY).balanceOf(address(this)) - before;
        _mint(receiver, shares);
        _refundAssets(_tokens);
        emit Deposit(amounts, shares, receiver);
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
        require(receiver != address(0), "ZA");
        address[6] memory _tokens = tokens;
        _burn(msg.sender, shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount(shares);
        IBeefy(BEEFY).withdraw(userAmount);
        IERC20(BEEFY).safeTransfer(DEV_ADD, devAmount);
        uint256 earned = IERC20(CRV_LP).balanceOf(address(this));
        IERC20(CRV_LP).safeApprove(ZAP, earned);
        uint256[6] memory rcv_amounts = ICurveMatic(ZAP).remove_liquidity(
            POOL,
            earned,
            min_amounts,
            true
        );

        for (uint256 i; i < _tokens.length; ) {
            if (rcv_amounts[i] > 0) {
                if (i == 0) {
                    (bool success, ) = payable(receiver).call{
                        value: rcv_amounts[i]
                    }("");
                    require(success, "TRANSFER_FAILED");
                } else {
                    IERC20(_tokens[i]).safeTransfer(receiver, rcv_amounts[i]);
                }
            }
            unchecked {
                ++i;
            }
        }
        emit Withdraw(rcv_amounts, shares, receiver);
    }

    /// @notice withdraw all amount in any one of six asset acc to the shareAmount
    /// @param shares amount of share token
    /// @param min_amount minimum amount out acc to share
    /// @param index [MATIC,DAI,USDC,USDT,WBTC,WETH] of token in amount to be withdrawn
    /// @param receiver tokens receiver
    function withdrawInOne(
        uint256 shares,
        uint256 min_amount,
        uint256 index,
        address receiver
    ) external {
        require(receiver != address(0), "ZA");
        require(index < 6, "Invalid index");
        _burn(msg.sender, shares);
        (uint256 devAmount, uint256 userAmount) = _calculateAmount(shares);
        IBeefy(BEEFY).withdraw(userAmount);
        IERC20(BEEFY).safeTransfer(DEV_ADD, devAmount);
        uint256 earned = IERC20(CRV_LP).balanceOf(address(this));
        IERC20(CRV_LP).safeApprove(ZAP, earned);
        uint256 rcv_amount = ICurveMatic(ZAP).remove_liquidity_one_coin(
            POOL,
            earned,
            index,
            min_amount,
            index == 0 ? true : false
        );
        if (rcv_amount > 0) {
            if (index == 0) {
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


    function _refundAssets(address[6] memory _tokens) internal {
        bool success;

        uint256 amount = address(this).balance;
        if (amount > 0) {
            (success, ) = payable(msg.sender).call{value: amount}("");
            require(success, "TRANSFER_FAILED");
        }
        for (uint256 i = 1; i < _tokens.length; ) {
            amount = IERC20(_tokens[i]).balanceOf(address(this));
            if (amount > 0) {
                IERC20(_tokens[i]).safeTransfer(msg.sender, amount);
            }
            unchecked {
                ++i;
            }
        }
    }

    function _calculateAmount(
        uint256 shares
    ) internal view returns (uint256 devAmount, uint256 userAmount) {
        devAmount = (shares * PLATFORM_CHARGES) / HUNDRED;
        userAmount = shares - devAmount;
    }
}
