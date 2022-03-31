// SPDX-License-Identifier: UNLICENSED

import "../lib/ds-test/src/test.sol";
import "../lib/forge-std/src/stdlib.sol";
import "../lib/forge-std/src/Vm.sol";
import "../lib/forge-std/src/console.sol";

import "../contracts/Connext.sol";

abstract contract ForgeHelper is DSTest {
  // ============ Libraries ============
  using stdStorage for StdStorage;

  // ============ Storage ============
  Vm public constant vm = Vm(HEVM_ADDRESS);

  StdStorage public stdstore;

  address public constant NATIVE_ASSET = address(0);
}


abstract contract ForgeConnextHelper is ForgeHelper {
  // ============ Libraries ============
  using stdStorage for StdStorage;

  // ============ Storage ============

  Connext connext;

  uint256 domain = 1;
  address bridgeRouter = address(11111);
  address tokenRegistry = address(22222);
  address wrapper = address(33333);
  address admin = address(44444);

  // ============ Utils ============

  function setConnext() public {
    connext = new Connext();
    vm.prank(admin);
    connext.initialize(domain, payable(bridgeRouter), tokenRegistry, wrapper);
  }

  // https://github.com/brockelmore/forge-std
  // specifically here with overriding mappings: https://github.com/brockelmore/forge-std/blob/99107e3e39f27339d224575756d4548c08639bc0/src/test/StdStorage.t.sol#L189-L192
  function setApprovedRouter(address _router, bool _approved) internal {
    uint256 writeVal = _approved ? 1 : 0;
    stdstore.target(address(connext)).sig(connext.approvedRouters.selector).with_key(_router).checked_write(writeVal);
  }

  function setApprovedAsset(address _asset, bool _approved) internal {
    uint256 writeVal = _approved ? 1 : 0;
    stdstore.target(address(connext)).sig(connext.approvedAssets.selector).with_key(_asset).checked_write(writeVal);
  }
}
