// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
pragma experimental ABIEncoderV2;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { TransferHelper } from "./libraries/TransferHelper.sol";
import { IPool } from "./interfaces/IPool.sol";

contract Pool is IPool {
    using TransferHelper for IERC20;

    address public immutable factory;
    IERC20 public immutable token;
    IERC20 public immutable numeraire;
    uint256 public immutable spread;

    constructor(
        address _factory,
        address _token,
        address _numeraire,
        uint256 _spread
    ) {
        factory = _factory;
        token = IERC20(_token);
        numeraire = IERC20(_numeraire);
        spread = _spread;
    }

    function numeraireBalance() public view override returns (uint256) {
        return numeraire.balanceOf(address(this));
    }

    function backedBalance() public view override returns (uint256) {
        return token.totalSupply() - token.balanceOf(address(this));
    }

    function redeemable(uint256 _amount) public view override returns (uint256) {
        return (_amount * numeraireBalance()) / backedBalance();
    }

    function sell(uint256 amount) external override returns (uint256 sent) {
        uint256 balance = backedBalance();
        (, uint256 received) = token.get(msg.sender, address(this), amount);
        uint256 toTransfer = (received * numeraireBalance()) / balance;
        (sent, ) = numeraire.send(msg.sender, toTransfer);

        if (redeemable(received) < toTransfer) revert Pool__Swap_Error();
    }

    function buy(uint256 amount) external override returns (uint256 sent) {
        uint256 balance = numeraireBalance();
        (, uint256 received) = numeraire.get(msg.sender, address(this), amount);
        uint256 toTransfer = (received * backedBalance() * 10000) / (balance * (10000 + spread));
        uint256 initialRedeemable = (toTransfer * balance) / backedBalance();
        (sent, ) = token.send(msg.sender, toTransfer);

        if (redeemable(toTransfer) < initialRedeemable) revert Pool__Swap_Error();
    }
}
