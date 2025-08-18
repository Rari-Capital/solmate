// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {MockAuthChild} from "./utils/mocks/MockAuthChild.sol";
import {MockAuthority} from "./utils/mocks/MockAuthority.sol";

import {Authority} from "../auth/Auth.sol";

contract OutOfOrderAuthority is Authority {
    function canCall(
        address,
        address,
        bytes4
    ) public pure override returns (bool) {
        revert("OUT_OF_ORDER");
    }
}

contract AuthTest is DSTestPlus {
    MockAuthChild mockAuthChild;

    function setUp() public {
        mockAuthChild = new MockAuthChild();
    }

    function testTransferOwnershipAsOwner() public {
        mockAuthChild.transferOwnership(address(0xBEEF));
        assertEq(mockAuthChild.owner(), address(0xBEEF));
    }

    function testSetAuthorityAsOwner() public {
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
        assertEq(address(mockAuthChild.authority()), address(0xBEEF));
    }

    function testCallFunctionAsOwner() public {
        mockAuthChild.updateFlag();
    }

    function testTransferOwnershipWithPermissiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.transferOwnership(address(this));
    }

    function testSetAuthorityWithPermissiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
    }

    function testCallFunctionWithPermissiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.updateFlag();
    }

    function testSetAuthorityAsOwnerWithOutOfOrderAuthority() public {
        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        mockAuthChild.setAuthority(new MockAuthority(true));
    }

    function testFailTransferOwnershipAsNonOwner() public {
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.transferOwnership(address(0xBEEF));
    }

    function testFailSetAuthorityAsNonOwner() public {
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
    }

    function testFailCallFunctionAsNonOwner() public {
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.updateFlag();
    }

    function testFailTransferOwnershipWithRestrictiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.transferOwnership(address(this));
    }

    function testFailSetAuthorityWithRestrictiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
    }

    function testFailCallFunctionWithRestrictiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.transferOwnership(address(0));
        mockAuthChild.updateFlag();
    }

    function testFailTransferOwnershipAsOwnerWithOutOfOrderAuthority() public {
        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        mockAuthChild.transferOwnership(address(0));
    }

    function testFailCallFunctionAsOwnerWithOutOfOrderAuthority() public {
        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        mockAuthChild.updateFlag();
    }

    function testTransferOwnershipAsOwner(address newOwner) public {
        mockAuthChild.transferOwnership(newOwner);
        assertEq(mockAuthChild.owner(), newOwner);
    }

    function testSetAuthorityAsOwner(Authority newAuthority) public {
        mockAuthChild.setAuthority(newAuthority);
        assertEq(address(mockAuthChild.authority()), address(newAuthority));
    }

    function testTransferOwnershipWithPermissiveAuthority(address deadOwner, address newOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.transferOwnership(newOwner);
    }

    function testSetAuthorityWithPermissiveAuthority(address deadOwner, Authority newAuthority) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.setAuthority(newAuthority);
    }

    function testCallFunctionWithPermissiveAuthority(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.updateFlag();
    }

    function testFailTransferOwnershipAsNonOwner(address deadOwner, address newOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.transferOwnership(newOwner);
    }

    function testFailSetAuthorityAsNonOwner(address deadOwner, Authority newAuthority) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.setAuthority(newAuthority);
    }

    function testFailCallFunctionAsNonOwner(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.updateFlag();
    }

    function testFailTransferOwnershipWithRestrictiveAuthority(address deadOwner, address newOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.transferOwnership(newOwner);
    }

    function testFailSetAuthorityWithRestrictiveAuthority(address deadOwner, Authority newAuthority) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.setAuthority(newAuthority);
    }

    function testFailCallFunctionWithRestrictiveAuthority(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.transferOwnership(deadOwner);
        mockAuthChild.updateFlag();
    }

    function testFailTransferOwnershipAsOwnerWithOutOfOrderAuthority(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        mockAuthChild.transferOwnership(deadOwner);
    }
}
