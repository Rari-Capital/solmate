// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import "forge-std/Test.sol";

import {TestPlus} from "./utils/TestPlus.sol";

import {SafeCastLib} from "../utils/SafeCastLib.sol";

contract SafeCastLibTest is TestPlus {
    function testSafeCastTo248() public {
        assertEq(SafeCastLib.safeCastTo248(2.5e45), 2.5e45);
        assertEq(SafeCastLib.safeCastTo248(2.5e27), 2.5e27);
    }

    function testSafeCastTo224() public {
        assertEq(SafeCastLib.safeCastTo224(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo224(2.5e27), 2.5e27);
    }

    function testSafeCastTo192() public {
        assertEq(SafeCastLib.safeCastTo192(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo192(2.5e27), 2.5e27);
    }

    function testSafeCastTo160() public {
        assertEq(SafeCastLib.safeCastTo160(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo160(2.5e27), 2.5e27);
    }

    function testSafeCastTo128() public {
        assertEq(SafeCastLib.safeCastTo128(2.5e27), 2.5e27);
        assertEq(SafeCastLib.safeCastTo128(2.5e18), 2.5e18);
    }

    function testSafeCastTo96() public {
        assertEq(SafeCastLib.safeCastTo96(2.5e18), 2.5e18);
        assertEq(SafeCastLib.safeCastTo96(2.5e17), 2.5e17);
    }

    function testSafeCastTo64() public {
        assertEq(SafeCastLib.safeCastTo64(2.5e18), 2.5e18);
        assertEq(SafeCastLib.safeCastTo64(2.5e17), 2.5e17);
    }

    function testSafeCastTo32() public {
        assertEq(SafeCastLib.safeCastTo32(2.5e8), 2.5e8);
        assertEq(SafeCastLib.safeCastTo32(2.5e7), 2.5e7);
    }

    function testSafeCastTo8() public {
        assertEq(SafeCastLib.safeCastTo8(100), 100);
        assertEq(SafeCastLib.safeCastTo8(250), 250);
    }

    function testBadSafeCastTo248() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo248(type(uint248).max + 1);
    }

    function testBadSafeCastTo224() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo224(type(uint224).max + 1);
    }

    function testBadSafeCastTo192() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo192(type(uint192).max + 1);
    }

    function testBadSafeCastTo160() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo160(type(uint160).max + 1);
    }

    function testBadSafeCastTo128() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo128(type(uint128).max + 1);
    }

    function testBadSafeCastTo96() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo96(type(uint96).max + 1);
    }

    function testBadSafeCastTo64() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo64(type(uint64).max + 1);
    }

    function testBadSafeCastTo32() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo32(type(uint32).max + 1);
    }

    function testBadSafeCastTo8() public {
        vm.expectRevert(stdError.arithmeticError);
        SafeCastLib.safeCastTo8(type(uint8).max + 1);
    }

    function testSafeCastTo248(uint256 x) public {
        x = bound(x, 0, type(uint248).max);

        assertEq(SafeCastLib.safeCastTo248(x), x);
    }

    function testSafeCastTo224(uint256 x) public {
        x = bound(x, 0, type(uint224).max);

        assertEq(SafeCastLib.safeCastTo224(x), x);
    }

    function testSafeCastTo192(uint256 x) public {
        x = bound(x, 0, type(uint192).max);

        assertEq(SafeCastLib.safeCastTo192(x), x);
    }

    function testSafeCastTo160(uint256 x) public {
        x = bound(x, 0, type(uint160).max);

        assertEq(SafeCastLib.safeCastTo160(x), x);
    }

    function testSafeCastTo128(uint256 x) public {
        x = bound(x, 0, type(uint128).max);

        assertEq(SafeCastLib.safeCastTo128(x), x);
    }

    function testSafeCastTo96(uint256 x) public {
        x = bound(x, 0, type(uint96).max);

        assertEq(SafeCastLib.safeCastTo96(x), x);
    }

    function testSafeCastTo64(uint256 x) public {
        x = bound(x, 0, type(uint64).max);

        assertEq(SafeCastLib.safeCastTo64(x), x);
    }

    function testSafeCastTo32(uint256 x) public {
        x = bound(x, 0, type(uint32).max);

        assertEq(SafeCastLib.safeCastTo32(x), x);
    }

    function testSafeCastTo8(uint256 x) public {
        x = bound(x, 0, type(uint8).max);

        assertEq(SafeCastLib.safeCastTo8(x), x);
    }

    function testBadSafeCastTo248(uint256 x) public {
        x = bound(x, uint256(type(uint248).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo248(x);
    }

    function testBadSafeCastTo224(uint256 x) public {
        x = bound(x, uint256(type(uint224).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo224(x);
    }

    function testBadSafeCastTo192(uint256 x) public {
        x = bound(x, uint256(type(uint192).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo192(x);
    }

    function testBadSafeCastTo160(uint256 x) public {
        x = bound(x, uint256(type(uint160).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo160(x);
    }

    function testBadSafeCastTo128(uint256 x) public {
        x = bound(x, uint256(type(uint128).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo128(x);
    }

    function testBadSafeCastTo96(uint256 x) public {
        x = bound(x, uint256(type(uint96).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo96(x);
    }

    function testBadSafeCastTo64(uint256 x) public {
        x = bound(x, uint256(type(uint64).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo64(x);
    }

    function testBadSafeCastTo32(uint256 x) public {
        x = bound(x, uint256(type(uint32).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo32(x);
    }

    function testBadSafeCastTo8(uint256 x) public {
        x = bound(x, uint256(type(uint8).max) + 1, type(uint256).max);

        vm.expectRevert();
        SafeCastLib.safeCastTo8(x);
    }
}
