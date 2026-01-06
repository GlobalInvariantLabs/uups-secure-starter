// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {TestHarnessV1} from "../contracts/harness/TestHarnessV1.sol";
import {TestHarnessV2} from "../contracts/harness/TestHarnessV2.sol";

contract UUPSBaseTest is Test {
    address admin = address(0xA11CE);
    address upgrader = address(0xB0B);
    address attacker = address(0xBAD);

    TestHarnessV1 implV1;
    TestHarnessV2 implV2;

    TestHarnessV1 proxiedV1;

    function setUp() public {
        implV1 = new TestHarnessV1();
        implV2 = new TestHarnessV2();

        bytes memory initData = abi.encodeCall(TestHarnessV1.initialize, (admin, upgrader, 123));

        ERC1967Proxy proxy = new ERC1967Proxy(address(implV1), initData);
        proxiedV1 = TestHarnessV1(address(proxy));
    }

    function test_initializes_state() public {
        assertEq(proxiedV1.value(), 123);
    }

    function test_admin_can_setValue_whenNotPaused() public {
        vm.prank(admin);
        proxiedV1.setValue(999);
        assertEq(proxiedV1.value(), 999);
    }

    function test_nonAdmin_cannot_setValue() public {
        vm.prank(attacker);
        vm.expectRevert();
        proxiedV1.setValue(1);
    }

    function test_pause_blocks_state_changes() public {
        vm.prank(admin);
        proxiedV1.pause();

        vm.prank(admin);
        vm.expectRevert();
        proxiedV1.setValue(777);
    }

    function test_onlyUpgrader_can_upgrade() public {
        // attacker fails
        vm.prank(attacker);
        vm.expectRevert();
        proxiedV1.upgradeToAndCall(address(implV2), "");

        // admin fails (unless admin is also upgrader)
        vm.prank(admin);
        vm.expectRevert();
        proxiedV1.upgradeToAndCall(address(implV2), "");

        // upgrader succeeds
        vm.prank(upgrader);
        proxiedV1.upgradeToAndCall(address(implV2), "");

        // After upgrade, call new function via V2 interface
        uint256 v = TestHarnessV2(address(proxiedV1)).version();
        assertEq(v, 2);
    }
}
