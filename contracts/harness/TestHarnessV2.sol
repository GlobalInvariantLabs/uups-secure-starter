// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {TestHarnessV1} from "./TestHarnessV1.sol";

/// @notice V2 extends V1 and adds a version() function to validate upgrade wiring end-to-end.
contract TestHarnessV2 is TestHarnessV1 {
    function version() external pure returns (uint256) {
        return 2;
    }
}
