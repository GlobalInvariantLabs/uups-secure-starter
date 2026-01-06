// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {TestHarnessV1} from "./TestHarnessV1.sol";

contract TestHarnessV2 is TestHarnessV1 {
    function version() external pure returns (uint256) {
        return 2;
    }
}