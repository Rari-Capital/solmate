// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import {TestPlus} from "./utils/TestPlus.sol";

contract TestPlusTest is TestPlus {
    function testBound() public {
        assertEq(bound(5, 0, 4), 0);
        assertEq(bound(0, 69, 69), 69);
        assertEq(bound(0, 68, 69), 68);
        assertEq(bound(10, 150, 190), 174);
        assertEq(bound(300, 2800, 3200), 3107);
        assertEq(bound(9999, 1337, 6666), 4669);
    }

    function testBoundMinBiggerThanMax() public {
        vm.expectRevert("MAX_LESS_THAN_MIN");
        bound(5, 100, 10);
    }

    function testRelApproxEqBothZeroesPasses() public {
        assertRelApproxEq(0, 0, 1e18);
        assertRelApproxEq(0, 0, 0);
    }

    function testBound(
        uint256 num,
        uint256 min,
        uint256 max
    ) public {
        if (min > max) (min, max) = (max, min);

        uint256 bounded = bound(num, min, max);

        assertGe(bounded, min);
        assertLe(bounded, max);
    }

    function testBoundMinBiggerThanMax(
        uint256 num,
        uint256 min,
        uint256 max
    ) public {
        if (max == min) {
            unchecked {
                min++; // Overflow is handled below.
            }
        }

        if (max > min) (min, max) = (max, min);

        vm.expectRevert("MAX_LESS_THAN_MIN");
        bound(num, min, max);
    }
}
