// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {Bytes32AddressLib} from "../utils/Bytes32AddressLib.sol";

contract Bytes32AddressLibTest is DSTestPlus {
    address private testAddr = 0xfEEDFaCEcaFeBEEFfEEDFACecaFEBeeFfeEdfAce;
    bytes32 private testAddrBytes32 = 0xfeedfacecafebeeffeedfacecafebeeffeedface000000000000000000000000;

    function testFillLast12Bytes() public {
        assertEq(Bytes32AddressLib.fillLast12Bytes(testAddr), testAddrBytes32);
    }

    function testFromLast20Bytes() public {
        assertEq(
            Bytes32AddressLib.fromLast20Bytes(0xfeedfacecafebeeffeedfacecafebeeffeedfacecafebeeffeedfacecafebeef),
            0xCAfeBeefFeedfAceCAFeBEEffEEDfaCecafEBeeF
        );
    }

    function testFromFirst20Bytes() public {
        assertEq(Bytes32AddressLib.fromFirst20Bytes(testAddrBytes32), testAddr);
    }

    function testFromFirst20BytesFuzz(address addr) public {
        bytes32 addrBytes32 = bytes32(bytes20(addr));

        assertEq(Bytes32AddressLib.fillLast12Bytes(addr), addrBytes32);
        assertEq(Bytes32AddressLib.fromFirst20Bytes(addrBytes32), addr);
    }
}
