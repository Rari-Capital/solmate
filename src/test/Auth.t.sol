// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import {MockAuthChild} from "./utils/mocks/MockAuthChild.sol";
import {MockAuthority} from "./utils/mocks/MockAuthority.sol";
import {TestPlus} from "./utils/TestPlus.sol";
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

contract AuthTest is TestPlus {
    MockAuthChild mockAuthChild;

    function setUp() public {
        mockAuthChild = new MockAuthChild();
    }

    function testSetOwnerAsOwner() public {
        mockAuthChild.setOwner(address(0xBEEF));
        assertEq(mockAuthChild.owner(), address(0xBEEF));
    }

    function testSetAuthorityAsOwner() public {
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
        assertEq(address(mockAuthChild.authority()), address(0xBEEF));
    }

    function testCallFunctionAsOwner() public {
        mockAuthChild.updateFlag();
    }

    function testSetOwnerWithPermissiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.setOwner(address(0));
        mockAuthChild.setOwner(address(this));
    }

    function testSetAuthorityWithPermissiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.setOwner(address(0));
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
    }

    function testCallFunctionWithPermissiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.setOwner(address(0));
        mockAuthChild.updateFlag();
    }

    function testSetAuthorityAsOwnerWithOutOfOrderAuthority() public {
        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        mockAuthChild.setAuthority(new MockAuthority(true));
    }

    function testSetOwnerAsNonOwner() public {
        mockAuthChild.setOwner(address(0));
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.setOwner(address(0xBEEF));
    }

    function testSetAuthorityAsNonOwner() public {
        mockAuthChild.setOwner(address(0));
        // Fails since MockAuthChild uses Authority(address(0)) which can't call `canCall` function
        vm.expectRevert();
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
    }

    function testCallFunctionAsNonOwner() public {
        mockAuthChild.setOwner(address(0));
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.updateFlag();
    }

    function testSetOwnerWithRestrictiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.setOwner(address(0));
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.setOwner(address(this));
    }

    function testSetAuthorityWithRestrictiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.setOwner(address(0));
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.setAuthority(Authority(address(0xBEEF)));
    }

    function testCallFunctionWithRestrictiveAuthority() public {
        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.setOwner(address(0));
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.updateFlag();
    }

    function testSetOwnerAsOwnerWithOutOfOrderAuthority() public {
        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        vm.expectRevert("OUT_OF_ORDER");
        mockAuthChild.setOwner(address(0));
    }

    function testCallFunctionAsOwnerWithOutOfOrderAuthority() public {
        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        vm.expectRevert("OUT_OF_ORDER");
        mockAuthChild.updateFlag();
    }

    function testSetOwnerAsOwner(address newOwner) public {
        mockAuthChild.setOwner(newOwner);
        assertEq(mockAuthChild.owner(), newOwner);
    }

    function testSetAuthorityAsOwner(Authority newAuthority) public {
        mockAuthChild.setAuthority(newAuthority);
        assertEq(address(mockAuthChild.authority()), address(newAuthority));
    }

    function testSetOwnerWithPermissiveAuthority(address deadOwner, address newOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.setOwner(deadOwner);
        mockAuthChild.setOwner(newOwner);
    }

    function testSetAuthorityWithPermissiveAuthority(address deadOwner, Authority newAuthority) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.setOwner(deadOwner);
        mockAuthChild.setAuthority(newAuthority);
    }

    function testCallFunctionWithPermissiveAuthority(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(true));
        mockAuthChild.setOwner(deadOwner);
        mockAuthChild.updateFlag();
    }

    function testSetOwnerAsNonOwner(address deadOwner, address newOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setOwner(deadOwner);
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.setOwner(newOwner);
    }

    function testSetAuthorityAsNonOwner(address deadOwner, Authority newAuthority) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setOwner(deadOwner);
        // Fails since MockAuthChild uses Authority(address(0)) which can't call `canCall` function
        vm.expectRevert();
        mockAuthChild.setAuthority(newAuthority);
    }

    function testCallFunctionAsNonOwner(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setOwner(deadOwner);
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.updateFlag();
    }

    function testSetOwnerWithRestrictiveAuthority(address deadOwner, address newOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.setOwner(deadOwner);
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.setOwner(newOwner);
    }

    function testSetAuthorityWithRestrictiveAuthority(address deadOwner, Authority newAuthority) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.setOwner(deadOwner);
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.setAuthority(newAuthority);
    }

    function testCallFunctionWithRestrictiveAuthority(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new MockAuthority(false));
        mockAuthChild.setOwner(deadOwner);
        vm.expectRevert("UNAUTHORIZED");
        mockAuthChild.updateFlag();
    }

    function testSetOwnerAsOwnerWithOutOfOrderAuthority(address deadOwner) public {
        if (deadOwner == address(this)) deadOwner = address(0);

        mockAuthChild.setAuthority(new OutOfOrderAuthority());
        vm.expectRevert("OUT_OF_ORDER");
        mockAuthChild.setOwner(deadOwner);
    }
}
