// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {MockOwned} from "./utils/mocks/MockOwned.sol";

contract OwnedTest is DSTestPlus {
    MockOwned mockOwned;

    function setUp() public {
        mockOwned = new MockOwned();
    }

    function testTransferOwnership() public {
        testTransferOwnership(address(0xBEEF));
    }

    function testCallFunctionAsNonOwner() public {
        testCallFunctionAsNonOwner(address(0));
    }

    function testCallFunctionAsOwner() public {
        mockOwned.updateFlag();
    }

    function testTransferOwnership(address newOwner) public {
        mockOwned.transferOwnership(newOwner);

        assertEq(mockOwned.owner(), newOwner);
    }

    function testCallFunctionAsNonOwner(address owner) public {
        hevm.assume(owner != address(this));

        mockOwned.transferOwnership(owner);

        hevm.expectRevert("UNAUTHORIZED");
        mockOwned.updateFlag();
    }
}
