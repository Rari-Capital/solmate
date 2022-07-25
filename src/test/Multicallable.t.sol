// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {MockMulticallable} from "./utils/mocks/MockMulticallable.sol";

contract MulticallableTest is DSTestPlus {
    MockMulticallable multicallable;

    function setUp() public {
        multicallable = new MockMulticallable();
    }

    function testMulticallableRevertWithMessage(string memory revertMessage) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSelector(MockMulticallable.revertsWithString.selector, revertMessage);
        hevm.expectRevert(bytes(revertMessage));
        multicallable.multicall(data);
    }

    function testMulticallableRevertWithMessage() public {
        testMulticallableRevertWithMessage("Milady");
    }

    function testMulticallableRevertWithCustomError() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSelector(MockMulticallable.revertsWithCustomError.selector);
        hevm.expectRevert(MockMulticallable.CustomError.selector);
        multicallable.multicall(data);
    }

    function testMulticallableReturnDataIsProperlyEncoded(
        uint256 a0,
        uint256 b0,
        uint256 a1,
        uint256 b1
    ) public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSelector(MockMulticallable.returnsTuple.selector, a0, b0);
        data[1] = abi.encodeWithSelector(MockMulticallable.returnsTuple.selector, a1, b1);
        bytes[] memory returnedData = multicallable.multicall(data);
        MockMulticallable.Tuple memory t0 = abi.decode(returnedData[0], (MockMulticallable.Tuple));
        MockMulticallable.Tuple memory t1 = abi.decode(returnedData[1], (MockMulticallable.Tuple));
        assertEq(t0.a, a0);
        assertEq(t0.b, b0);
        assertEq(t1.a, a1);
        assertEq(t1.b, b1);
    }

    function testMulticallableReturnDataIsProperlyEncoded(string memory sIn) public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSelector(MockMulticallable.returnsString.selector, sIn);
        string memory sOut = abi.decode(multicallable.multicall(data)[0], (string));
        assertEq(sIn, sOut);
    }

    function testMulticallableReturnDataIsProperlyEncoded() public {
        testMulticallableReturnDataIsProperlyEncoded(0, 1, 2, 3);
    }

    function testMulticallableBenchmark() public {
        unchecked {
            bytes[] memory data = new bytes[](10);
            for (uint256 i; i != data.length; ++i) {
                data[i] = abi.encodeWithSelector(MockMulticallable.returnsTuple.selector, i, i + 1);
            }
            bytes[] memory returnedData = multicallable.multicall(data);
            assertEq(returnedData.length, data.length);
        }
    }

    function testMulticallableOriginalBenchmark() public {
        unchecked {
            bytes[] memory data = new bytes[](10);
            for (uint256 i; i != data.length; ++i) {
                data[i] = abi.encodeWithSelector(MockMulticallable.returnsTuple.selector, i, i + 1);
            }
            bytes[] memory returnedData = multicallable.multicallOriginal(data);
            assertEq(returnedData.length, data.length);
        }
    }

    function testMulticallableWithNoData() public {
        bytes[] memory data = new bytes[](0);
        assertEq(multicallable.multicall(data).length, 0);
    }

    function testMulticallablePreservesMsgValue() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSelector(MockMulticallable.pay.selector);
        multicallable.multicall{value: 3}(data);
        assertEq(multicallable.paid(), 3);
    }

    function testMulticallablePreservesMsgValueUsedTwice() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSelector(MockMulticallable.pay.selector);
        data[1] = abi.encodeWithSelector(MockMulticallable.pay.selector);
        multicallable.multicall{value: 3}(data);
        assertEq(multicallable.paid(), 6);
    }

    function testMulticallablePreservesMsgSender() public {
        address caller = address(uint160(0xbeef));
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSelector(MockMulticallable.returnsSender.selector);
        hevm.prank(caller);
        address returnedAddress = abi.decode(multicallable.multicall(data)[0], (address));
        assertEq(caller, returnedAddress);
    }
}
