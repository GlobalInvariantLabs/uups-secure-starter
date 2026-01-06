// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/*
 * UpgradeableBase
 *
 * A conservative UUPS base contract intended for audit-ready systems.
 * Explicit role separation, explicit upgrade authorization, and
 * minimal surface area by design.
 */

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

abstract contract UpgradeableBase is
    Initializable,
    UUPSUpgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable
{
    /*//////////////////////////////////////////////////////////////
                                ROLES
    //////////////////////////////////////////////////////////////*/

    bytes32 public constant ADMIN_ROLE     = keccak256("ADMIN_ROLE");
    bytes32 public constant UPGRADER_ROLE  = keccak256("UPGRADER_ROLE");

    /*//////////////////////////////////////////////////////////////
                              INITIALIZER
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Base initializer.
     * Must be called by the concrete implementation initializer.
     *
     * Role separation is explicit:
     * - ADMIN_ROLE: governance, pausing, role management
     * - UPGRADER_ROLE: implementation upgrades only
     */
    function __UpgradeableBase_init(address admin, address upgrader)
        internal
        onlyInitializing
    {
        __AccessControl_init();
        __Pausable_init();
        __UUPSUpgradeable_init();

        require(admin != address(0), "ADMIN_ZERO");
        require(upgrader != address(0), "UPGRADER_ZERO");

        _grantRole(ADMIN_ROLE, admin);
        _grantRole(UPGRADER_ROLE, upgrader);

        // ADMIN manages roles
        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
        _setRoleAdmin(UPGRADER_ROLE, ADMIN_ROLE);
    }

    /*//////////////////////////////////////////////////////////////
                           PAUSE CONTROL
    //////////////////////////////////////////////////////////////*/

    function pause() external onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    /*//////////////////////////////////////////////////////////////
                       UUPS AUTHORIZATION
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev UUPS upgrade authorization hook.
     *
     * Explicitly restricted to UPGRADER_ROLE.
     * Pausing does NOT block upgrades by default.
     * Governance should decide whether to revoke upgrader instead.
     */
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {
        require(newImplementation != address(0), "IMPL_ZERO");
    }

    /*//////////////////////////////////////////////////////////////
                        STORAGE GAP
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Storage gap for future extensions.
     * Do not remove or reorder.
     */
    uint256[50] private __gap;
}