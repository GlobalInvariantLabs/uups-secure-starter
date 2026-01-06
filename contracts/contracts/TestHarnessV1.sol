// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {UpgradeableBase} from "./base/UpgradeableBase.sol";

contract TestHarnessV1 is UpgradeableBase {
    uint256 public value;

    function initialize(address admin, address upgrader, uint256 initialValue) external initializer {
        __UpgradeableBase_init(admin, upgrader);
        value = initialValue;
    }

    function setValue(uint256 newValue) external whenNotPaused onlyRole(ADMIN_ROLE) {
        value = newValue;
    }
}