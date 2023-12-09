// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract LiquidityPool is Pausable {
    using SafeERC20 for IERC20;

    IERC20 public usdcToken;
    uint256 public constant lockupDuration = 7 days;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event EarningsWithdrawn(address indexed user, uint256 amount);

    modifier updateStaking(address _user) {
        Stake storage userStake = stakes[_user];
        if (userStake.amount > 0) {
            uint256 elapsedTime = block.timestamp - userStake.timestamp;
            userStake.amount += (userStake.amount * elapsedTime * 10**18) / lockupDuration / 365 days;
            userStake.timestamp = block.timestamp;
        }
        _;
    }

    constructor(address _usdcToken) {
        usdcToken = IERC20(_usdcToken);
    }

    function stake(uint256 _amount) external whenNotPaused updateStaking(msg.sender) {
        require(_amount > 0, "Amount must be greater than zero");

        usdcToken.safeTransferFrom(msg.sender, address(this), _amount);

        stakes[msg.sender] = Stake({
            amount: stakes[msg.sender].amount + _amount,
            timestamp: block.timestamp
        });

        emit Staked(msg.sender, _amount);
    }

    function unstake() external updateStaking(msg.sender) {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake to unstake");
        require(block.timestamp >= userStake.timestamp + lockupDuration, "Lockup period not over");

        uint256 amountToUnstake = userStake.amount;
        delete stakes[msg.sender];

        usdcToken.safeTransfer(msg.sender, amountToUnstake);

        emit Unstaked(msg.sender, amountToUnstake);
    }

    function withdrawEarnings() external updateStaking(msg.sender) {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No staked amount");
        require(block.timestamp >= userStake.timestamp + lockupDuration, "Lockup period not over");

        uint256 earnings = userStake.amount - (userStake.amount * 10**18) / 1 ether;
        userStake.amount -= earnings;

        usdcToken.safeTransfer(msg.sender, earnings);

        emit EarningsWithdrawn(msg.sender, earnings);
    }

    function getUserInfo(address _user) external view returns (uint256 stakedAmount, uint256 tvl, uint256 earningYield) {
        Stake storage userStake = stakes[_user];

        stakedAmount = userStake.amount;
        tvl = usdcToken.balanceOf(address(this));
        earningYield = (block.timestamp - userStake.timestamp) * 10**18 / lockupDuration;
    }
}
