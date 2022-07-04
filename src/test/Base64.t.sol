// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {Base64} from "../utils/Base64.sol";

contract Base64Test is DSTestPlus {
    function testBase64EncodeEmptyString() public {
        testBase64("", "");
    }

    function testBase64EncodeToStringWithDoublePadding() public {
        testBase64("test", "dGVzdA==");
    }

    function testBase64EncodeToStringWithSinglePadding() public {
        testBase64("test1", "dGVzdDE=");
    }

    function testBase64EncodeToStringWithNoPadding() public {
        testBase64("test12", "dGVzdDEy");
    }

    function testBase64EncodeSentence() public {
        testBase64(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdC4="
        );
    }

    function testBase64WordBoundary() public {
        // Base64.encode allocates memory in multiples of 32 bytes.
        // This checks if the amount of memory allocated is enough.
        testBase64("012345678901234567890", "MDEyMzQ1Njc4OTAxMjM0NTY3ODkw");
        testBase64("0123456789012345678901", "MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMQ==");
        testBase64("01234567890123456789012", "MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI=");
        testBase64("012345678901234567890123", "MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIz");
        testBase64("0123456789012345678901234", "MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNA==");
    }

    function testBase64(string memory input, string memory output) private {
        string memory encoded = Base64.encode(bytes(input));
        bool freeMemoryPointerIs32ByteAligned;
        assembly {
            let freeMemoryPointer := mload(0x40)
            // This ensures that the memory allocated is 32-byte aligned.
            freeMemoryPointerIs32ByteAligned := iszero(and(freeMemoryPointer, 31))
            // Write a non Base64 character to the free memory pointer.
            // If the allocated memory is insufficient, this will change the
            // encoded string and cause the subsequent asserts to fail.
            mstore(freeMemoryPointer, "#")
        }
        assertTrue(freeMemoryPointerIs32ByteAligned);
        assertEq(keccak256(bytes(encoded)), keccak256(bytes(output)));
    }
}
