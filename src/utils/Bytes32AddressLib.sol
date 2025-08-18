// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice Library for converting between addresses and bytes32 values.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/Bytes32AddressLib.sol)
library Bytes32AddressLib {
    /// @notice Converts a bytes32 value into an address.
    /// @param bytesValue The bytes32 value to convert.
    /// @return The resulting address.

    function fromLast20Bytes(bytes32 bytesValue) internal pure returns (address) {
        return address(uint160(uint256(bytesValue)));
    }

    /// @notice Converts an address to a bytes32 representation.
    /// @param addressValue The address to convert.
    /// @return The resulting bytes32 value.

    function fillLast12Bytes(address addressValue) internal pure returns (bytes32) {
        return bytes32(bytes20(addressValue));
    }
}
