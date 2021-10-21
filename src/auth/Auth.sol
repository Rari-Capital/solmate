// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.7.0;

/// @notice A generic interface for a contract which provides authorization data to an Auth instance.
/// @author Modified from Dappsys (https://github.com/dapphub/ds-auth/blob/master/src/auth.sol)
interface Authority {
    function canCall(
        address src,
        address dst,
        bytes4 sig
    ) external view returns (bool);
}

/// @notice Provides a flexible and updatable auth pattern which is completely separate from application logic.
/// @author Modified from Dappsys (https://github.com/dapphub/ds-auth/blob/master/src/auth.sol)
abstract contract Auth {
    event OwnerUpdated(address indexed owner);

    event AuthorityUpdated(Authority indexed authority);

    address public owner;

    Authority public authority;

    constructor(address _owner, Authority _authority) {
        owner = _owner;
        authority = _authority;

        emit OwnerUpdated(_owner);
        emit AuthorityUpdated(_authority);
    }

    function setOwner(address newOwner) public virtual requiresAuth {
        owner = newOwner;

        emit OwnerUpdated(owner);
    }

    function setAuthority(Authority newAuthority) public virtual requiresAuth {
        authority = newAuthority;

        emit AuthorityUpdated(authority);
    }

    function isAuthorized(address src, bytes4 sig) internal view virtual returns (bool) {
        if (src == address(this) || src == owner) return true;

        Authority cachedAuthority = authority;

        return address(cachedAuthority) != address(0) && cachedAuthority.canCall(src, address(this), sig);
    }

    modifier requiresAuth() {
        require(isAuthorized(msg.sender, msg.sig), "UNAUTHORIZED");

        _;
    }
}
