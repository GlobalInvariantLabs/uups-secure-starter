// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import {TestHarnessV1} from "../contracts/harness/TestHarnessV1.sol";
import {TestHarnessV2} from "../contracts/harness/TestHarnessV2.sol";

contract UpgradeSafetyTest is Test {
    function test_UpgradeStorageCompatibility_stub() public {
        // This is a minimal "safety rail" test:
        // - Ensures V2 still contains V1 state variable(s) and can read/write them after "upgrade".
        //
        // NOTE: This is a stub until a real proxy-based upgrade test is added.

        TestHarnessV2 v2 = new TestHarnessV2();

        // If V1 defines 'value' + setValue/getValue pattern, assert it still works in V2.
        // Adapt these two lines if your V1 uses different names.
        v2.setValue(123);
        assertEq(v2.value(), 123);

        // New function exists in V2
        assertEq(v2.version(), 2);
    }
}
