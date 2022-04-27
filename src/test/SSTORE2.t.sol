// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import {TestPlus} from "./utils/TestPlus.sol";

import {SSTORE2} from "../utils/SSTORE2.sol";

contract SSTORE2Test is TestPlus {
    function testWriteRead() public {
        bytes memory testBytes = abi.encode("this is a test");

        address pointer = SSTORE2.write(testBytes);

        assertBytesEq(SSTORE2.read(pointer), testBytes);
    }

    function testWriteReadFullStartBound() public {
        assertBytesEq(SSTORE2.read(SSTORE2.write(hex"11223344"), 0), hex"11223344");
    }

    function testWriteReadCustomStartBound() public {
        assertBytesEq(SSTORE2.read(SSTORE2.write(hex"11223344"), 1), hex"223344");
    }

    function testWriteReadFullBoundedRead() public {
        bytes memory testBytes = abi.encode("this is a test");

        assertBytesEq(SSTORE2.read(SSTORE2.write(testBytes), 0, testBytes.length), testBytes);
    }

    function testWriteReadCustomBounds() public {
        assertBytesEq(SSTORE2.read(SSTORE2.write(hex"11223344"), 1, 3), hex"2233");
    }

    function testWriteReadEmptyBound() public {
        SSTORE2.read(SSTORE2.write(hex"11223344"), 3, 3);
    }

    function testReadInvalidPointer() public {
        vm.expectRevert(stdError.arithmeticError);
        SSTORE2.read(DEAD_ADDRESS);
    }

    function testReadInvalidPointerCustomStartBound() public {
        vm.expectRevert(stdError.arithmeticError);
        SSTORE2.read(DEAD_ADDRESS, 1);
    }

    function testReadInvalidPointerCustomBounds() public {
        vm.expectRevert("OUT_OF_BOUNDS");
        SSTORE2.read(DEAD_ADDRESS, 2, 4);
    }

    function testWriteReadOutOfStartBound() public {
        address pointer = SSTORE2.write(hex"11223344");
        vm.expectRevert(stdError.arithmeticError);
        SSTORE2.read(pointer, 41000);
    }

    function testWriteReadEmptyOutOfBounds() public {
        address pointer = SSTORE2.write(hex"11223344");
        vm.expectRevert("OUT_OF_BOUNDS");
        SSTORE2.read(pointer, 42000, 42000);
    }

    function testWriteReadOutOfBounds() public {
        address pointer = SSTORE2.write(hex"11223344");
        vm.assume(pointer.code.length != 0);
        vm.expectRevert("OUT_OF_BOUNDS");
        SSTORE2.read(pointer, 41000, 42000);
    }

    function testWriteRead(bytes calldata testBytes) public {
        assertBytesEq(SSTORE2.read(SSTORE2.write(testBytes)), testBytes);
    }

    function testWriteReadCustomStartBound(bytes calldata testBytes, uint256 startIndex) public {
        vm.assume(testBytes.length != 0);

        startIndex = bound(startIndex, 0, testBytes.length);

        assertBytesEq(SSTORE2.read(SSTORE2.write(testBytes), startIndex), bytes(testBytes[startIndex:]));
    }

    function testWriteReadCustomBounds(
        bytes calldata testBytes,
        uint256 startIndex,
        uint256 endIndex
    ) public {
        vm.assume(testBytes.length != 0);

        endIndex = bound(endIndex, 0, testBytes.length);
        startIndex = bound(startIndex, 0, testBytes.length);

        if (startIndex > endIndex) (startIndex, endIndex) = (endIndex, startIndex);

        assertBytesEq(
            SSTORE2.read(SSTORE2.write(testBytes), startIndex, endIndex),
            bytes(testBytes[startIndex:endIndex])
        );
    }

    function testReadInvalidPointer(address pointer) public {
        vm.assume(pointer.code.length == 0);

        vm.expectRevert(stdError.arithmeticError);
        SSTORE2.read(pointer);
    }

    function testReadInvalidPointerCustomStartBound(address pointer, uint256 startIndex) public {
        vm.assume(pointer.code.length == 0);

        vm.expectRevert(stdError.arithmeticError);
        SSTORE2.read(pointer, startIndex);
    }

    function testReadInvalidPointerCustomBounds(
        address pointer,
        uint256 startIndex,
        uint256 endIndex
    ) public {
        startIndex = bound(startIndex, pointer.code.length, type(uint256).max - 1);
        endIndex = bound(endIndex, pointer.code.length, type(uint256).max - 1);
        if (startIndex > endIndex) (startIndex, endIndex) = (endIndex, startIndex);

        vm.expectRevert("OUT_OF_BOUNDS");
        SSTORE2.read(pointer, startIndex, endIndex);
    }

    function testWriteReadCustomStartBoundOutOfRange(bytes calldata testBytes, uint256 startIndex) public {
        vm.assume(testBytes.length != 0);
        startIndex = bound(startIndex, testBytes.length + 1, type(uint256).max - 1);

        address pointer = SSTORE2.write(testBytes);
        vm.expectRevert(stdError.arithmeticError);
        SSTORE2.read(pointer, startIndex);
    }

    function testWriteReadCustomBoundsOutOfRange(
        bytes calldata testBytes,
        uint256 startIndex,
        uint256 endIndex
    ) public {
        vm.assume(testBytes.length != 0);
        endIndex = bound(endIndex, testBytes.length + 1, type(uint256).max - 1);
        startIndex = bound(startIndex, testBytes.length + 1, type(uint256).max - 1);
        if (startIndex > endIndex) (startIndex, endIndex) = (endIndex, startIndex);

        address pointer = SSTORE2.write(testBytes);
        vm.expectRevert("OUT_OF_BOUNDS");
        SSTORE2.read(pointer, startIndex, endIndex);
    }
}
