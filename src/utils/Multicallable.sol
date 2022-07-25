// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @notice Contract that enables a single call to call multiple methods on itself.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/Multicallable.sol)
/// @author Modified from Solady (https://github.com/vectorized/solady/blob/main/src/utils/Multicallable.sol)
abstract contract Multicallable {
    function multicall(bytes[] calldata data) public payable returns (bytes[] memory results) {
        assembly {
            if data.length {
                results := mload(0x40) // Point `results` to start of free memory.
                mstore(results, data.length) // Store `data.length` into `results`.
                results := add(results, 0x20)

                // `shl` 5 is equivalent to multiplying by 0x20.
                let end := shl(5, data.length)
                // Copy the offsets from calldata into memory.
                calldatacopy(results, data.offset, end)
                // Pointer to the top of the memory (i.e. start of the free memory).
                let memPtr := add(results, end)
                end := add(results, end)

                // prettier-ignore
                for {} 1 {} {
                    // The offset of the current bytes in the calldata.
                    let o := add(data.offset, mload(results))
                    // Copy the current bytes from calldata to the memory.
                    calldatacopy(
                        memPtr,
                        add(o, 0x20), // The offset of the current bytes' bytes.
                        calldataload(o) // The length of the current bytes.
                    )
                    if iszero(delegatecall(gas(), address(), memPtr, calldataload(o), 0x00, 0x00)) {
                        // Bubble up the revert if the delegatecall reverts.
                        returndatacopy(0x00, 0x00, returndatasize())
                        revert(0x00, returndatasize())
                    }
                    // Append the current `memPtr` into `results`.
                    mstore(results, memPtr)
                    results := add(results, 0x20)
                    // Append the `returndatasize()`, and the return data.
                    mstore(memPtr, returndatasize())
                    returndatacopy(add(memPtr, 0x20), 0x00, returndatasize())
                    // Advance the `memPtr` by `returndatasize() + 0x20`,
                    // rounded up to the next multiple of 32.
                    memPtr := and(add(add(memPtr, returndatasize()), 0x3f), 0xffffffffffffffe0)
                    // prettier-ignore
                    if iszero(lt(results, end)) { break }
                }
                // Restore `results` and allocate memory for it.
                results := mload(0x40)
                mstore(0x40, memPtr)
            }
        }
    }
}
