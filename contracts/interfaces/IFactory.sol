// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
pragma experimental ABIEncoderV2;

interface IFactory {
    event PoolCreated(address indexed token, address indexed numeraire, uint256 spread, address pool);

    error Factory__Same_Tokens(address token, address numeraire);
    error Factory__Invalid_Token();
    error Factory__Pool_Already_Exists();

    function createPool(
        address token,
        address numeraire,
        uint256 spread
    ) external returns (address pool);

    function getPool(
        address token,
        address numeraire,
        uint256 spread
    ) external view returns (address pool);
}
