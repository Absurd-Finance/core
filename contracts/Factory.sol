// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
pragma experimental ABIEncoderV2;

import { IFactory } from "./interfaces/IFactory.sol";
import { Pool } from "./Pool.sol";

contract Factory is IFactory {
    mapping(address => mapping(address => mapping(uint256 => address))) public override getPool;

    function createPool(
        address token,
        address numeraire,
        uint256 spread
    ) external override returns (address pool) {
        if (token == numeraire) revert Factory__Same_Tokens(token, numeraire);

        if (token == address(0) || numeraire == address(0)) revert Factory__Invalid_Token();

        if (getPool[token][numeraire][spread] != address(0)) revert Factory__Pool_Already_Exists();

        pool = address(new Pool(address(this), token, numeraire, spread));
        getPool[token][numeraire][spread] = pool;

        emit PoolCreated(token, numeraire, spread, pool);
    }
}
