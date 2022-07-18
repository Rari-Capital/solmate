// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {ERC1155TokenReceiver} from "./ERC1155.sol";

/// @notice Minimalist and gas efficient ERC1155 implementation optimized for single supply ids.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155B.sol)
abstract contract ERC1155B {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 amount
    );

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] amounts
    );

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    event URI(string value, uint256 indexed id);

    /*//////////////////////////////////////////////////////////////
                             ERC1155 STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /*//////////////////////////////////////////////////////////////
                            ERC1155B STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(uint256 => address) public ownerOf;

    function balanceOf(address owner, uint256 id) public view virtual returns (uint256 bal) {
        address idOwner = ownerOf[id];

        assembly {
            // We avoid branching by using assembly to take
            // the bool output of eq() and use it as a uint.
            bal := eq(idOwner, owner)
        }
    }

    /*//////////////////////////////////////////////////////////////
                             METADATA LOGIC
    //////////////////////////////////////////////////////////////*/

    function uri(uint256 id) public view virtual returns (string memory);

    /*//////////////////////////////////////////////////////////////
                              CUSTOM ERRORS
    //////////////////////////////////////////////////////////////*/

    error NotAuthorized();

    error UnsafeRecipient();

    error InvalidRecipient();

    error InvalidFrom();

    error LengthMismatch();

    error WrongFrom();

    error InvalidAmount();

    error AlreadyMinted();

    error NotMinted();

    /*//////////////////////////////////////////////////////////////
                              ERC1155 LOGIC
    //////////////////////////////////////////////////////////////*/

    function setApprovalForAll(address operator, bool approved) public virtual {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) public virtual {
        if (msg.sender != from && !isApprovedForAll[from][msg.sender]) { revert NotAuthorized(); }

        if (from != ownerOf[id]) { revert WrongFrom(); } // Can only transfer from the owner.

        // Can only transfer 1 with ERC1155B.
        if (amount != 1) { revert InvalidAmount(); }

        ownerOf[id] = to;

        emit TransferSingle(msg.sender, from, to, id, amount);

        if (to.code.length != 0) {
            if (ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data) !=
                ERC1155TokenReceiver.onERC1155Received.selector) { revert UnsafeRecipient(); }
        } else { if (to == address(0)) { revert InvalidRecipient(); }}
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) public virtual {
        if (ids.length != amounts.length) { revert LengthMismatch(); }

        if (msg.sender != from && !isApprovedForAll[from][msg.sender]) { revert NotAuthorized(); }

        // Storing these outside the loop saves ~15 gas per iteration.
        uint256 id;
        uint256 amount;

        // Unchecked because the only math done is incrementing
        // the array index counter which cannot possibly overflow.
        unchecked {
            for (uint256 i = 0; i < ids.length; i++) {
                id = ids[i];
                amount = amounts[i];

                // Can only transfer from the owner.
                if (from != ownerOf[id]) { revert WrongFrom(); } // Can only transfer from the owner.

                // Can only transfer 1 with ERC1155B.
                if (amount != 1) { revert InvalidAmount(); }

                ownerOf[id] = to;
            }
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);

        if (to.code.length != 0) {
            if (
                ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, from, ids, amounts, data) !=
                ERC1155TokenReceiver.onERC1155BatchReceived.selector) { revert UnsafeRecipient(); }
        } else { if (to == address(0)) { revert InvalidRecipient(); }}
    }

    function balanceOfBatch(address[] calldata owners, uint256[] calldata ids)
        public
        view
        virtual
        returns (uint256[] memory balances)
    {
        if (owners.length != ids.length) { revert LengthMismatch(); }

        balances = new uint256[](owners.length);

        // Unchecked because the only math done is incrementing
        // the array index counter which cannot possibly overflow.
        unchecked {
            for (uint256 i = 0; i < owners.length; ++i) {
                balances[i] = balanceOf(owners[i], ids[i]);
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(
        address to,
        uint256 id,
        bytes memory data
    ) internal virtual {
        // Minting twice would effectively be a force transfer.
        if (ownerOf[id] != address(0)) { revert AlreadyMinted(); }

        ownerOf[id] = to;

        emit TransferSingle(msg.sender, address(0), to, id, 1);

        if (to.code.length != 0) {
            if (ERC1155TokenReceiver(to).onERC1155Received(msg.sender, address(0), id, 1, data) !=
                ERC1155TokenReceiver.onERC1155Received.selector) { revert UnsafeRecipient(); }
        } else { if (to == address(0)) { revert InvalidRecipient(); }}
    }

    function _batchMint(
        address to,
        uint256[] memory ids,
        bytes memory data
    ) internal virtual {
        uint256 idsLength = ids.length; // Saves MLOADs.

        // Generate an amounts array locally to use in the event below.
        uint256[] memory amounts = new uint256[](idsLength);

        uint256 id; // Storing outside the loop saves ~7 gas per iteration.

        // Unchecked because the only math done is incrementing
        // the array index counter which cannot possibly overflow.
        unchecked {
            for (uint256 i = 0; i < idsLength; ++i) {
                id = ids[i];

                // Minting twice would effectively be a force transfer.
                if (ownerOf[id] != address(0)) { revert AlreadyMinted(); }

                ownerOf[id] = to;

                amounts[i] = 1;
            }
        }

        emit TransferBatch(msg.sender, address(0), to, ids, amounts);

        if (to.code.length != 0) {
            if (ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, address(0), ids, amounts, data) !=
                ERC1155TokenReceiver.onERC1155BatchReceived.selector ) { revert UnsafeRecipient(); }
        } else { if (to == address(0)) { revert InvalidRecipient(); }}
    }

    function _batchBurn(address from, uint256[] memory ids) internal virtual {
        // Burning unminted tokens makes no sense.
        if (from == address(0)) { revert InvalidFrom(); }

        uint256 idsLength = ids.length; // Saves MLOADs.

        // Generate an amounts array locally to use in the event below.
        uint256[] memory amounts = new uint256[](idsLength);

        uint256 id; // Storing outside the loop saves ~7 gas per iteration.

        // Unchecked because the only math done is incrementing
        // the array index counter which cannot possibly overflow.
        unchecked {
            for (uint256 i = 0; i < idsLength; ++i) {
                id = ids[i];

                if (ownerOf[id] != from) { revert WrongFrom(); }

                ownerOf[id] = address(0);

                amounts[i] = 1;
            }
        }

        emit TransferBatch(msg.sender, from, address(0), ids, amounts);
    }

    function _burn(uint256 id) internal virtual {
        address owner = ownerOf[id];

        if (owner == address(0)) { revert NotMinted(); }

        ownerOf[id] = address(0);

        emit TransferSingle(msg.sender, owner, address(0), id, 1);
    }
}
