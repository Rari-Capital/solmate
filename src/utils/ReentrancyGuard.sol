// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @notice Gas optimized reentrancy protection for smart contracts.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
/// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    uint256 private locked = 1;

    modifier nonReentrant() virtual {
        // `require(locked == 1)` works fine in normal conditions.
        // When deployed via proxy, its value would be 0 by default.
        // Hence, instead of setting the storage slot manually, we can simply
        // check whether `locked < 2`.
        require(locked < 2, "REENTRANCY");

        locked = 2;

        _;

        locked = 1;
    }
}
