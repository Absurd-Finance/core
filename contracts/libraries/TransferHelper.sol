// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.6;
pragma experimental ABIEncoderV2;

import { IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

library TransferHelper {
    using SafeERC20 for IERC20;

    error TransferHelper__Insufficient_Token_Balance(address);
    error TransferHelper__Insufficient_Token_Allowance(address);

    function get(
        IERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal returns (uint256 sent, uint256 received) {
        if (token.balanceOf(from) < amount) revert TransferHelper__Insufficient_Token_Balance(address(token));

        if (token.allowance(from, to) < amount) revert TransferHelper__Insufficient_Token_Allowance(address(token));

        // computes transferred balance for tokens with tax on transfers
        uint256 prevAmountThis = token.balanceOf(to);
        uint256 prevAmountFrom = token.balanceOf(from);
        token.safeTransferFrom(from, to, amount);

        sent = prevAmountFrom - token.balanceOf(from);
        received = token.balanceOf(to) - prevAmountThis;
    }

    function send(
        IERC20 token,
        address to,
        uint256 amount
    ) internal returns (uint256 sent, uint256 received) {
        if (token.balanceOf(address(this)) < amount) revert TransferHelper__Insufficient_Token_Balance(address(token));

        // computes transferred balance for tokens with tax on transfers
        uint256 prevAmountThis = token.balanceOf(address(this));
        uint256 prevAmountTo = token.balanceOf(to);

        token.safeTransfer(to, amount);

        sent = prevAmountThis - token.balanceOf(address(this));
        received = token.balanceOf(to) - prevAmountTo;
    }
}
