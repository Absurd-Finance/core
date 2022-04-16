// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
pragma experimental ABIEncoderV2;

interface IPool {
    error Pool__Swap_Error();

    function numeraireBalance() external view returns (uint256);

    function backedBalance() external view returns (uint256);

    function redeemable(uint256 _amount) external view returns (uint256 obtained);

    function sell(uint256 amount) external returns (uint256 sent);

    function buy(uint256 amount) external returns (uint256 sent);
}
