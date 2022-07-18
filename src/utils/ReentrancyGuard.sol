// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @notice Gas optimized reentrancy protection for smart contracts.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
/// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    uint256 private locked = 1;

    error Reentrancy();

    modifier nonReentrant() virtual {
        if (locked != 1) { revert Reentrancy(); }

        locked = 2;

        _;

        locked = 1;
    }
}
