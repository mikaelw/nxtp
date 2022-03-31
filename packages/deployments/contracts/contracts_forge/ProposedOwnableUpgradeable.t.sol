// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "./ForgeHelper.sol";

import "../contracts/ProposedOwnableUpgradeable.sol";

contract ProposedOwnableUpgradeableTest is ForgeConnextHelper {
  // ============ Libraries ============
  using stdStorage for StdStorage;

  // ============ Storage ============

  address successor = address(2);

  // ============ Test set up ============

  function setUp() public {
    setConnext();
  }

  // ============ Utils ============

  // ============ owner ============

  // Should work
  function testOwner() public {
    assertTrue(connext.owner() == admin);
  }

  // ============ proposed ============

  // Should work
  function testProposed() public {}

  // ============ proposedTimestamp ============

  // Should work
  function testProposedTimestamp() public {}

  // ============ routerOwnershipTimestamp ============

  // Should work
  function testRouterOwnershipTimestamp() public {}

  // ============ assetOwnershipTimestamp ============

  // Should work
  function testAssetOwnershipTimestamp() public {}

  // ============ delay ============

  // Should work
  function testDelay() public {}

  // ============ isRouterOwnershipRenounced ============

  // Should work
  function testIsRouterOwnershipRenounced() public {}

  // ============ proposeRouterOwnershipRenunciation ============

  // Should work
  function testProposeRouterOwnershipRenunciation() public {}

  // ============ renounceRouterOwnership ============

  // Should work
  function testRenounceRouterOwnership() public {}

  // ============ isAssetOwnershipRenounced ============

  // Should work
  function testIsAssetOwnershipRenounced() public {}

  // ============ proposeAssetOwnershipRenunciation ============

  // Should work
  function testProposeAssetOwnershipRenunciation() public {}

  // ============ renounceAssetOwnership ============

  // Should work
  function testRenounceAssetOwnership() public {}

  // ============ renounced ============

  // Should work
  function testRenounced() public {}

  // ============ proposeNewOwner ============

  // Should fail if not proposing a new owner
  function testProposeSameOwner() public {
    vm.prank(admin);
    vm.expectRevert(abi.encodeWithSelector(ProposedOwnableUpgradeable.ProposedOwnableUpgradeable__proposeNewOwner_038.selector));
    connext.proposeNewOwner(admin);
  }

  // Should fail if proposing the same proposed owner
  function testProposeDuplicateNewOwner() public {
    vm.startPrank(admin);
    connext.proposeNewOwner(successor);
    vm.expectRevert(abi.encodeWithSelector(ProposedOwnableUpgradeable.ProposedOwnableUpgradeable__proposeNewOwner_036.selector));
    connext.proposeNewOwner(successor);
    vm.stopPrank();
  }

  // Should work
  function testProposeNewOwner() public {
    uint256 timestamp = 12345;
    vm.warp(timestamp);
    vm.prank(admin);
    connext.proposeNewOwner(successor);
    assertTrue(connext.proposed() == successor);
    assertTrue(connext.proposedTimestamp() == timestamp);
  }

  // ============ renounceOwnership ============

  // Should work
  function testRenounceOwnership() public {}

  // ============ acceptProposedOwner ============

  // Should work
  function testAcceptProposedOwner() public {
    uint256 timestamp = 12345;
    vm.warp(timestamp);
    vm.prank(admin);
    connext.proposeNewOwner(successor);
    vm.warp(timestamp + 7 days);
    vm.prank(successor);
    connext.acceptProposedOwner();
  }
}