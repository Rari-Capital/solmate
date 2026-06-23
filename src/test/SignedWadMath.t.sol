// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {wadMul, wadDiv, wadExp, wadLn, wadPow} from "../utils/SignedWadMath.sol";

contract SignedWadMathTest is DSTestPlus {
    function testWadExp() public {
        assertEq(wadExp(0), 1e18);
        assertApproxEq(uint256(wadExp(1e18)), 2718281828459045235, 2);
    }

    function testWadExpBoundaries() public {
        assertEq(wadExp(-42139678854452767551), 0);
    }

    function testWadExpOverflowReverts() public {
        hevm.expectRevert("EXP_OVERFLOW");
        this.wadExpOverflowRevertsHelper();
    }

    function wadExpOverflowRevertsHelper() external pure {
        wadExp(135305999368893231589);
    }

    function testWadLn() public {
        assertEq(wadLn(1e18), 0);
        assertApproxEq(uint256(wadLn(2e18)), 693147180559945309, 2);
    }

    function testWadPowRoundTrip() public {
        assertEq(wadPow(1e18, 0), 1e18);
        assertApproxEq(uint256(wadPow(2e18, 1e18)), 2e18, 2);
    }

    function testWadLnZeroReverts() public {
        hevm.expectRevert("UNDEFINED");
        this.wadLnZeroRevertsHelper();
    }

    function wadLnZeroRevertsHelper() external pure {
        wadLn(0);
    }

    function testWadMul(
        uint256 x,
        uint256 y,
        bool negX,
        bool negY
    ) public {
        x = bound(x, 0, 99999999999999e18);
        y = bound(x, 0, 99999999999999e18);

        int256 xPrime = negX ? -int256(x) : int256(x);
        int256 yPrime = negY ? -int256(y) : int256(y);

        assertEq(wadMul(xPrime, yPrime), (xPrime * yPrime) / 1e18);
    }

    function testWadMulEdgeCaseReverts() public {
        hevm.expectRevert();
        this.wadMulEdgeCaseRevertsHelper();
    }

    function wadMulEdgeCaseRevertsHelper() external pure {
        int256 x = -1;
        int256 y = type(int256).min;

        wadMul(x, y);
    }

    function testWadMulEdgeCase2Reverts() public {
        hevm.expectRevert();
        this.wadMulEdgeCase2RevertsHelper();
    }

    function wadMulEdgeCase2RevertsHelper() external pure {
        int256 x = type(int256).min;
        int256 y = -1;

        wadMul(x, y);
    }

    function testWadMulOverflowReverts(int256 x, int256 y) public {
        // Ignore cases where x * y does not overflow.
        unchecked {
            if (x == 0 || (x * y) / x == y) return;
        }

        hevm.expectRevert();
        this.wadMulOverflowRevertsHelper(x, y);
    }

    function wadMulOverflowRevertsHelper(int256 x, int256 y) external pure {
        wadMul(x, y);
    }

    function testWadDiv(
        uint256 x,
        uint256 y,
        bool negX,
        bool negY
    ) public {
        x = bound(x, 0, 99999999e18);
        y = bound(x, 1, 99999999e18);

        int256 xPrime = negX ? -int256(x) : int256(x);
        int256 yPrime = negY ? -int256(y) : int256(y);

        assertEq(wadDiv(xPrime, yPrime), (xPrime * 1e18) / yPrime);
    }

    function testWadDivOverflowReverts(int256 x, int256 y) public {
        // Ignore cases where x * WAD does not overflow or y is 0.
        unchecked {
            if (y == 0 || (x * 1e18) / 1e18 == x) return;
        }

        hevm.expectRevert();
        this.wadDivOverflowRevertsHelper(x, y);
    }

    function wadDivOverflowRevertsHelper(int256 x, int256 y) external pure {
        wadDiv(x, y);
    }

    function testWadDivZeroDenominatorReverts(int256 x) public {
        hevm.expectRevert();
        this.wadDivZeroDenominatorRevertsHelper(x);
    }

    function wadDivZeroDenominatorRevertsHelper(int256 x) external pure {
        wadDiv(x, 0);
    }
}
