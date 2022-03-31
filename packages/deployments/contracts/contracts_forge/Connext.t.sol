// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "./ForgeHelper.sol";

import "../contracts/Connext.sol";

// running tests (with logging on failure):
// yarn workspace @connext/nxtp-contracts test:forge -vvv
// run a single test:
// yarn workspace @connext/nxtp-contracts test:forge -m testAddRouterAlreadyApproved -vvv

// other forge commands: yarn workspace @connext/nxtp-contracts forge <CMD>
// see docs here: https://onbjerg.github.io/foundry-book/index.html

contract ConnextTest is ForgeConnextHelper {

  // ============ Libraries ============
  using stdStorage for StdStorage;

  // ============ Storage ============

  // ============ Test set up ============

  function setUp() public {
    setConnext();
  }

  // ============ addRouter ============

  // Fail if not called by owner
  function testAddRouterOwnable() public {
    vm.prank(address(0));
    vm.expectRevert(abi.encodeWithSelector(ProposedOwnableUpgradeable.ProposedOwnableUpgradeable__onlyOwner_029.selector));
    connext.addRouter(address(1));
  }

  // Fail if adding address(0) as router
  function testAddRouterZeroAddress() public {
    vm.expectRevert(abi.encodeWithSelector(Connext.Connext__addRouter_001.selector));
    connext.addRouter(address(0));
  }

  // Fail if adding a duplicate router
  function testAddRouterAlreadyApproved() public {
    setApprovedRouter(address(1), true);
    vm.expectRevert(abi.encodeWithSelector(Connext.Connext__addRouter_032.selector));
    connext.addRouter(address(1));
  }

  // Should work
  function testAddRouter() public {
    connext.addRouter(address(1));
    assertTrue(connext.approvedRouters(address(1)));
  }

  // ============ removeRouter ============

  // Fail if not called by owner
  function testRemoveRouterOwnable() public {
    vm.prank(address(0));
    vm.expectRevert(abi.encodeWithSelector(ProposedOwnableUpgradeable.ProposedOwnableUpgradeable__onlyOwner_029.selector));
    connext.removeRouter(address(1));
  }

  // Fail if removing address(0) as router
  function testRemoveRouterZeroAddress() public {
    vm.expectRevert(abi.encodeWithSelector(Connext.Connext__removeRouter_001.selector));
    connext.removeRouter(address(0));
  }

  // Fail if removing a non-existent router
  function testAddRouterNotApproved() public {
    setApprovedRouter(address(1), false);
    vm.expectRevert(abi.encodeWithSelector(Connext.Connext__removeRouter_033.selector));
    connext.removeRouter(address(1));
  }

  // Should work
  function testRemoveRouter() public {
    setApprovedRouter(address(1), true);
    connext.removeRouter(address(1));
    assertTrue(!connext.approvedRouters(address(1)));
  }
}
