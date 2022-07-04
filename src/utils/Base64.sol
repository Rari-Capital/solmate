// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @notice Library to encode strings in Base64.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/Base64.sol)
/// @author Modified from (https://github.com/Brechtpd/base64/blob/main/base64.sol) by Brecht Devos - <brecht@loopring.org>.
library Base64 {
    function encode(bytes memory data) internal pure returns (string memory result) {
        assembly {
            let dataLength := mload(data)

            if dataLength {
                // Multiply by 4/3 rounded up.
                // The `shl(2, ...)` is equivalent to multiplying by 4.
                let encodedLength := shl(2, div(add(dataLength, 2), 3))

                // Set `result` to point to the start of the free memory.
                result := mload(0x40)

                // Write the length of the string.
                mstore(result, encodedLength)

                // Store the table into the scratch space.
                // Offsetted by -1 byte so that the `mload` will load the character.
                // We will rewrite the free memory pointer at `0x40` later with
                // the allocated size.
                mstore(0x1f, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef")
                mstore(0x3f, "ghijklmnopqrstuvwxyz0123456789+/")

                // Skip the first slot, which stores the length.
                let ptr := add(result, 0x20)
                let end := add(ptr, encodedLength)

                // Run over the input, 3 bytes at a time.
                // prettier-ignore
                for {} iszero(eq(ptr, end)) {} {
                    data := add(data, 3) // Advance 3 bytes.
                    let input := mload(data)

                    // Write 4 characters. Optimized for fewer stack operations.
                    mstore8(    ptr    , mload(and(shr(18, input), 0x3F)))
                    mstore8(add(ptr, 1), mload(and(shr(12, input), 0x3F)))
                    mstore8(add(ptr, 2), mload(and(shr( 6, input), 0x3F)))
                    mstore8(add(ptr, 3), mload(and(        input , 0x3F)))
                    
                    ptr := add(ptr, 4) // Advance 4 bytes.
                }

                // Offset `ptr` and pad with '='. We can simply write over the end.
                // The `byte(...)` part is equivalent to `[0, 2, 1][dataLength % 3]`.
                mstore(sub(ptr, byte(mod(dataLength, 3), "\x00\x02\x01")), "==")

                // Allocate the memory for the string.
                // Add 31 and mask with `not(0x1f)` to round the
                // free memory pointer up the next multiple of 32.
                mstore(0x40, and(add(end, 31), not(0x1f)))
            }
        }
    }
}
