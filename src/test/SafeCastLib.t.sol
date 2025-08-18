// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {SafeCastLib} from "../utils/SafeCastLib.sol";

contract SafeCastLibTest is DSTestPlus {
    function testSafeCastTo248() public {
        assertEq(SafeCastLib.safeCastTo248(2.5e45), 2.5e45);
        assertEq(SafeCastLib.safeCastTo248(2.5e27), 2.5e27);
    }

    function testSafeCastTo240() public {
        assertEq(SafeCastLib.safeCastTo240(2.5e45), 2.5e45);
        assertEq(SafeCastLib.safeCastTo240(2.5e27), 2.5e27);
    }

    function testSafeCastTo232() public {
        assertEq(SafeCastLib.safeCastTo232(2.5e45), 2.5e45);
        assertEq(SafeCastLib.safeCastTo232(2.5e27), 2.5e27);
    }

    function testSafeCastTo224() public {
        assertEq(SafeCastLib.safeCastTo224(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo224(2.5e27), 2.5e27);
    }

    function testSafeCastTo216() public {
        assertEq(SafeCastLib.safeCastTo216(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo216(2.5e27), 2.5e27);
    }

    function testSafeCastTo208() public {
        assertEq(SafeCastLib.safeCastTo208(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo208(2.5e27), 2.5e27);
    }

    function testSafeCastTo200() public {
        assertEq(SafeCastLib.safeCastTo200(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo200(2.5e27), 2.5e27);
    }

    function testSafeCastTo192() public {
        assertEq(SafeCastLib.safeCastTo192(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo192(2.5e27), 2.5e27);
    }

    function testSafeCastTo184() public {
        assertEq(SafeCastLib.safeCastTo184(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo184(2.5e27), 2.5e27);
    }

    function testSafeCastTo176() public {
        assertEq(SafeCastLib.safeCastTo176(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo176(2.5e27), 2.5e27);
    }

    function testSafeCastTo168() public {
        assertEq(SafeCastLib.safeCastTo168(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo168(2.5e27), 2.5e27);
    }

    function testSafeCastTo160() public {
        assertEq(SafeCastLib.safeCastTo160(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo160(2.5e27), 2.5e27);
    }

    function testSafeCastTo152() public {
        assertEq(SafeCastLib.safeCastTo152(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo152(2.5e27), 2.5e27);
    }

    function testSafeCastTo144() public {
        assertEq(SafeCastLib.safeCastTo144(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo144(2.5e27), 2.5e27);
    }

    function testSafeCastTo136() public {
        assertEq(SafeCastLib.safeCastTo136(2.5e36), 2.5e36);
        assertEq(SafeCastLib.safeCastTo136(2.5e27), 2.5e27);
    }

    function testSafeCastTo128() public {
        assertEq(SafeCastLib.safeCastTo128(2.5e27), 2.5e27);
        assertEq(SafeCastLib.safeCastTo128(2.5e18), 2.5e18);
    }

    function testSafeCastTo120() public {
        assertEq(SafeCastLib.safeCastTo120(2.5e27), 2.5e27);
        assertEq(SafeCastLib.safeCastTo120(2.5e18), 2.5e18);
    }

    function testSafeCastTo112() public {
        assertEq(SafeCastLib.safeCastTo112(2.5e27), 2.5e27);
        assertEq(SafeCastLib.safeCastTo112(2.5e18), 2.5e18);
    }

    function testSafeCastTo104() public {
        assertEq(SafeCastLib.safeCastTo104(2.5e27), 2.5e27);
        assertEq(SafeCastLib.safeCastTo104(2.5e18), 2.5e18);
    }

    function testSafeCastTo96() public {
        assertEq(SafeCastLib.safeCastTo96(2.5e18), 2.5e18);
        assertEq(SafeCastLib.safeCastTo96(2.5e17), 2.5e17);
    }

    function testSafeCastTo64() public {
        assertEq(SafeCastLib.safeCastTo64(2.5e18), 2.5e18);
        assertEq(SafeCastLib.safeCastTo64(2.5e17), 2.5e17);
    }

    function testSafeCastTo56() public {
        assertEq(SafeCastLib.safeCastTo56(2.5e16), 2.5e16);
        assertEq(SafeCastLib.safeCastTo56(2.5e15), 2.5e15);
    }

    function testSafeCastTo48() public {
        assertEq(SafeCastLib.safeCastTo48(2.5e12), 2.5e12);
        assertEq(SafeCastLib.safeCastTo48(2.5e11), 2.5e11);
    }

    function testSafeCastTo40() public {
        assertEq(SafeCastLib.safeCastTo40(2.5e10), 2.5e10);
        assertEq(SafeCastLib.safeCastTo40(2.5e9), 2.5e9);
    }

    function testSafeCastTo32() public {
        assertEq(SafeCastLib.safeCastTo32(2.5e8), 2.5e8);
        assertEq(SafeCastLib.safeCastTo32(2.5e7), 2.5e7);
    }

    function testSafeCastTo24() public {
        assertEq(SafeCastLib.safeCastTo24(2.5e4), 2.5e4);
        assertEq(SafeCastLib.safeCastTo24(2.5e3), 2.5e3);
    }

    function testSafeCastTo16() public {
        assertEq(SafeCastLib.safeCastTo16(2.5e3), 2.5e3);
        assertEq(SafeCastLib.safeCastTo16(2.5e2), 2.5e2);
    }

    function testSafeCastTo8() public {
        assertEq(SafeCastLib.safeCastTo8(100), 100);
        assertEq(SafeCastLib.safeCastTo8(250), 250);
    }

    function testFailSafeCastTo248() public pure {
        SafeCastLib.safeCastTo248(type(uint248).max + 1);
    }

    function testFailSafeCastTo240() public pure {
        SafeCastLib.safeCastTo240(type(uint240).max + 1);
    }

    function testFailSafeCastTo232() public pure {
        SafeCastLib.safeCastTo232(type(uint232).max + 1);
    }

    function testFailSafeCastTo224() public pure {
        SafeCastLib.safeCastTo224(type(uint224).max + 1);
    }

    function testFailSafeCastTo216() public pure {
        SafeCastLib.safeCastTo216(type(uint216).max + 1);
    }

    function testFailSafeCastTo208() public pure {
        SafeCastLib.safeCastTo208(type(uint208).max + 1);
    }

    function testFailSafeCastTo200() public pure {
        SafeCastLib.safeCastTo200(type(uint200).max + 1);
    }

    function testFailSafeCastTo192() public pure {
        SafeCastLib.safeCastTo192(type(uint192).max + 1);
    }

    function testFailSafeCastTo184() public pure {
        SafeCastLib.safeCastTo184(type(uint184).max + 1);
    }

    function testFailSafeCastTo176() public pure {
        SafeCastLib.safeCastTo176(type(uint176).max + 1);
    }

    function testFailSafeCastTo168() public pure {
        SafeCastLib.safeCastTo168(type(uint168).max + 1);
    }

    function testFailSafeCastTo160() public pure {
        SafeCastLib.safeCastTo160(type(uint160).max + 1);
    }

    function testFailSafeCastTo152() public pure {
        SafeCastLib.safeCastTo152(type(uint152).max + 1);
    }

    function testFailSafeCastTo144() public pure {
        SafeCastLib.safeCastTo144(type(uint144).max + 1);
    }

    function testFailSafeCastTo136() public pure {
        SafeCastLib.safeCastTo136(type(uint136).max + 1);
    }

    function testFailSafeCastTo128() public pure {
        SafeCastLib.safeCastTo128(type(uint128).max + 1);
    }

    function testFailSafeCastTo120() public pure {
        SafeCastLib.safeCastTo120(type(uint120).max + 1);
    }

    function testFailSafeCastTo112() public pure {
        SafeCastLib.safeCastTo112(type(uint112).max + 1);
    }

    function testFailSafeCastTo104() public pure {
        SafeCastLib.safeCastTo104(type(uint104).max + 1);
    }

    function testFailSafeCastTo96() public pure {
        SafeCastLib.safeCastTo96(type(uint96).max + 1);
    }

    function testFailSafeCastTo88() public pure {
        SafeCastLib.safeCastTo88(type(uint88).max + 1);
    }

    function testFailSafeCastTo80() public pure {
        SafeCastLib.safeCastTo80(type(uint80).max + 1);
    }

    function testFailSafeCastTo72() public pure {
        SafeCastLib.safeCastTo72(type(uint72).max + 1);
    }

    function testFailSafeCastTo64() public pure {
        SafeCastLib.safeCastTo64(type(uint64).max + 1);
    }

    function testFailSafeCastTo56() public pure {
        SafeCastLib.safeCastTo56(type(uint56).max + 1);
    }

    function testFailSafeCastTo48() public pure {
        SafeCastLib.safeCastTo48(type(uint48).max + 1);
    }

    function testFailSafeCastTo40() public pure {
        SafeCastLib.safeCastTo40(type(uint40).max + 1);
    }

    function testFailSafeCastTo32() public pure {
        SafeCastLib.safeCastTo32(type(uint32).max + 1);
    }

    function testFailSafeCastTo24() public pure {
        SafeCastLib.safeCastTo24(type(uint24).max + 1);
    }

    function testFailSafeCastTo16() public pure {
        SafeCastLib.safeCastTo16(type(uint16).max + 1);
    }

    function testFailSafeCastTo8() public pure {
        SafeCastLib.safeCastTo8(type(uint8).max + 1);
    }

    function testSafeCastTo248(uint256 x) public {
        x = bound(x, 0, type(uint248).max);

        assertEq(SafeCastLib.safeCastTo248(x), x);
    }

    function testSafeCastTo240(uint256 x) public {
        x = bound(x, 0, type(uint240).max);

        assertEq(SafeCastLib.safeCastTo240(x), x);
    }

    function testSafeCastTo232(uint256 x) public {
        x = bound(x, 0, type(uint232).max);

        assertEq(SafeCastLib.safeCastTo232(x), x);
    }

    function testSafeCastTo224(uint256 x) public {
        x = bound(x, 0, type(uint224).max);

        assertEq(SafeCastLib.safeCastTo224(x), x);
    }

    function testSafeCastTo216(uint256 x) public {
        x = bound(x, 0, type(uint216).max);

        assertEq(SafeCastLib.safeCastTo216(x), x);
    }

    function testSafeCastTo208(uint256 x) public {
        x = bound(x, 0, type(uint208).max);

        assertEq(SafeCastLib.safeCastTo208(x), x);
    }

    function testSafeCastTo200(uint256 x) public {
        x = bound(x, 0, type(uint200).max);

        assertEq(SafeCastLib.safeCastTo200(x), x);
    }

    function testSafeCastTo192(uint256 x) public {
        x = bound(x, 0, type(uint192).max);

        assertEq(SafeCastLib.safeCastTo192(x), x);
    }

    function testSafeCastTo184(uint256 x) public {
        x = bound(x, 0, type(uint184).max);

        assertEq(SafeCastLib.safeCastTo184(x), x);
    }

    function testSafeCastTo176(uint256 x) public {
        x = bound(x, 0, type(uint176).max);

        assertEq(SafeCastLib.safeCastTo176(x), x);
    }

    function testSafeCastTo168(uint256 x) public {
        x = bound(x, 0, type(uint168).max);

        assertEq(SafeCastLib.safeCastTo168(x), x);
    }

    function testSafeCastTo160(uint256 x) public {
        x = bound(x, 0, type(uint160).max);

        assertEq(SafeCastLib.safeCastTo160(x), x);
    }

    function testSafeCastTo152(uint256 x) public {
        x = bound(x, 0, type(uint152).max);

        assertEq(SafeCastLib.safeCastTo152(x), x);
    }

    function testSafeCastTo144(uint256 x) public {
        x = bound(x, 0, type(uint144).max);

        assertEq(SafeCastLib.safeCastTo144(x), x);
    }

    function testSafeCastTo136(uint256 x) public {
        x = bound(x, 0, type(uint136).max);

        assertEq(SafeCastLib.safeCastTo136(x), x);
    }

    function testSafeCastTo128(uint256 x) public {
        x = bound(x, 0, type(uint128).max);

        assertEq(SafeCastLib.safeCastTo128(x), x);
    }

    function testSafeCastTo120(uint256 x) public {
        x = bound(x, 0, type(uint120).max);

        assertEq(SafeCastLib.safeCastTo120(x), x);
    }

    function testSafeCastTo112(uint256 x) public {
        x = bound(x, 0, type(uint112).max);

        assertEq(SafeCastLib.safeCastTo112(x), x);
    }

    function testSafeCastTo104(uint256 x) public {
        x = bound(x, 0, type(uint104).max);

        assertEq(SafeCastLib.safeCastTo104(x), x);
    }

    function testSafeCastTo96(uint256 x) public {
        x = bound(x, 0, type(uint96).max);

        assertEq(SafeCastLib.safeCastTo96(x), x);
    }

    function testSafeCastTo88(uint256 x) public {
        x = bound(x, 0, type(uint88).max);

        assertEq(SafeCastLib.safeCastTo88(x), x);
    }

    function testSafeCastTo80(uint256 x) public {
        x = bound(x, 0, type(uint80).max);

        assertEq(SafeCastLib.safeCastTo80(x), x);
    }

    function testSafeCastTo72(uint256 x) public {
        x = bound(x, 0, type(uint72).max);

        assertEq(SafeCastLib.safeCastTo72(x), x);
    }

    function testSafeCastTo64(uint256 x) public {
        x = bound(x, 0, type(uint64).max);

        assertEq(SafeCastLib.safeCastTo64(x), x);
    }

    function testSafeCastTo56(uint256 x) public {
        x = bound(x, 0, type(uint56).max);

        assertEq(SafeCastLib.safeCastTo56(x), x);
    }

    function testSafeCastTo48(uint256 x) public {
        x = bound(x, 0, type(uint48).max);

        assertEq(SafeCastLib.safeCastTo48(x), x);
    }

    function testSafeCastTo40(uint256 x) public {
        x = bound(x, 0, type(uint40).max);

        assertEq(SafeCastLib.safeCastTo40(x), x);
    }

    function testSafeCastTo32(uint256 x) public {
        x = bound(x, 0, type(uint32).max);

        assertEq(SafeCastLib.safeCastTo32(x), x);
    }

    function testSafeCastTo24(uint256 x) public {
        x = bound(x, 0, type(uint24).max);

        assertEq(SafeCastLib.safeCastTo24(x), x);
    }

    function testSafeCastTo16(uint256 x) public {
        x = bound(x, 0, type(uint16).max);

        assertEq(SafeCastLib.safeCastTo16(x), x);
    }

    function testSafeCastTo8(uint256 x) public {
        x = bound(x, 0, type(uint8).max);

        assertEq(SafeCastLib.safeCastTo8(x), x);
    }

    function testFailSafeCastTo248(uint256 x) public {
        x = bound(x, type(uint248).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo248(x);
    }

    function testFailSafeCastTo240(uint256 x) public {
        x = bound(x, type(uint240).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo240(x);
    }

    function testFailSafeCastTo232(uint256 x) public {
        x = bound(x, type(uint232).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo232(x);
    }

    function testFailSafeCastTo224(uint256 x) public {
        x = bound(x, type(uint224).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo224(x);
    }

    function testFailSafeCastTo216(uint256 x) public {
        x = bound(x, type(uint216).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo216(x);
    }

    function testFailSafeCastTo208(uint256 x) public {
        x = bound(x, type(uint208).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo208(x);
    }

    function testFailSafeCastTo200(uint256 x) public {
        x = bound(x, type(uint200).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo200(x);
    }

    function testFailSafeCastTo192(uint256 x) public {
        x = bound(x, type(uint192).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo192(x);
    }

    function testFailSafeCastTo184(uint256 x) public {
        x = bound(x, type(uint184).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo184(x);
    }

    function testFailSafeCastTo176(uint256 x) public {
        x = bound(x, type(uint176).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo176(x);
    }

    function testFailSafeCastTo168(uint256 x) public {
        x = bound(x, type(uint168).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo168(x);
    }

    function testFailSafeCastTo160(uint256 x) public {
        x = bound(x, type(uint160).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo160(x);
    }

    function testFailSafeCastTo152(uint256 x) public {
        x = bound(x, type(uint152).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo152(x);
    }

    function testFailSafeCastTo144(uint256 x) public {
        x = bound(x, type(uint144).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo144(x);
    }

    function testFailSafeCastTo136(uint256 x) public {
        x = bound(x, type(uint136).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo136(x);
    }

    function testFailSafeCastTo128(uint256 x) public {
        x = bound(x, type(uint128).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo128(x);
    }

    function testFailSafeCastTo120(uint256 x) public {
        x = bound(x, type(uint120).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo120(x);
    }

    function testFailSafeCastTo112(uint256 x) public {
        x = bound(x, type(uint112).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo112(x);
    }

    function testFailSafeCastTo104(uint256 x) public {
        x = bound(x, type(uint104).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo104(x);
    }

    function testFailSafeCastTo96(uint256 x) public {
        x = bound(x, type(uint96).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo96(x);
    }

    function testFailSafeCastTo88(uint256 x) public {
        x = bound(x, type(uint88).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo88(x);
    }

    function testFailSafeCastTo80(uint256 x) public {
        x = bound(x, type(uint80).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo80(x);
    }

    function testFailSafeCastTo72(uint256 x) public {
        x = bound(x, type(uint72).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo72(x);
    }

    function testFailSafeCastTo64(uint256 x) public {
        x = bound(x, type(uint64).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo64(x);
    }

    function testFailSafeCastTo56(uint256 x) public {
        x = bound(x, type(uint56).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo56(x);
    }

    function testFailSafeCastTo48(uint256 x) public {
        x = bound(x, type(uint48).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo48(x);
    }

    function testFailSafeCastTo40(uint256 x) public {
        x = bound(x, type(uint40).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo40(x);
    }

    function testFailSafeCastTo32(uint256 x) public {
        x = bound(x, type(uint32).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo32(x);
    }

    function testFailSafeCastTo24(uint256 x) public {
        x = bound(x, type(uint24).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo24(x);
    }

    function testFailSafeCastTo16(uint256 x) public {
        x = bound(x, type(uint16).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo16(x);
    }

    function testFailSafeCastTo8(uint256 x) public {
        x = bound(x, type(uint8).max + 1, type(uint256).max);

        SafeCastLib.safeCastTo8(x);
    }
}
