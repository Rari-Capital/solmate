// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DSInvariantTest} from "./utils/DSInvariantTest.sol";

import {MockERC1155B} from "./utils/mocks/MockERC1155B.sol";
import {ERC1155BUser} from "./utils/users/ERC1155BUser.sol";

import {ERC1155TokenReceiver} from "../tokens/ERC1155.sol";

// TODO: test invalid_amount errors
// TODO: test ownerOf()
// TODO: fuzz testing
// TODO: test custom safe batch transfer
// TODO: test cant burn unminted tokens

contract ERC1155BRecipient is ERC1155TokenReceiver {
    address public operator;
    address public from;
    uint256 public id;
    uint256 public amount;
    bytes public mintData;

    function onERC1155Received(
        address _operator,
        address _from,
        uint256 _id,
        uint256 _amount,
        bytes calldata _data
    ) public override returns (bytes4) {
        operator = _operator;
        from = _from;
        id = _id;
        amount = _amount;
        mintData = _data;

        return ERC1155TokenReceiver.onERC1155Received.selector;
    }

    address public batchOperator;
    address public batchFrom;
    uint256[] internal _batchIds;
    uint256[] internal _batchAmounts;
    bytes public batchData;

    function batchIds() external view returns (uint256[] memory) {
        return _batchIds;
    }

    function batchAmounts() external view returns (uint256[] memory) {
        return _batchAmounts;
    }

    function onERC1155BatchReceived(
        address _operator,
        address _from,
        uint256[] calldata _ids,
        uint256[] calldata _amounts,
        bytes calldata _data
    ) external override returns (bytes4) {
        batchOperator = _operator;
        batchFrom = _from;
        _batchIds = _ids;
        _batchAmounts = _amounts;
        batchData = _data;

        return ERC1155TokenReceiver.onERC1155BatchReceived.selector;
    }
}

contract RevertingERC1155Recipient is ERC1155TokenReceiver {
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) public pure override returns (bytes4) {
        revert(string(abi.encodePacked(ERC1155TokenReceiver.onERC1155Received.selector)));
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure override returns (bytes4) {
        revert(string(abi.encodePacked(ERC1155TokenReceiver.onERC1155BatchReceived.selector)));
    }
}

contract WrongReturnDataERC1155BRecipient is ERC1155TokenReceiver {
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) public pure override returns (bytes4) {
        return 0xCAFEBEEF;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure override returns (bytes4) {
        return 0xCAFEBEEF;
    }
}

contract NonERC1155BRecipient {}

contract ERC1155BTest is DSTestPlus, ERC1155TokenReceiver {
    MockERC1155B token;

    mapping(address => mapping(uint256 => uint256)) public userMintAmounts;
    mapping(address => mapping(uint256 => uint256)) public userTransferOrBurnAmounts;

    function setUp() public {
        token = new MockERC1155B();
    }

    function testMintToEOA() public {
        token.mint(address(0xBEEF), 1337, "");

        assertEq(token.balanceOf(address(0xBEEF), 1337), 1);
    }

    function testMintToERC1155Recipient() public {
        ERC1155BRecipient to = new ERC1155BRecipient();

        token.mint(address(to), 1337, "testing 123");

        assertEq(token.balanceOf(address(to), 1337), 1);

        assertEq(to.operator(), address(this));
        assertEq(to.from(), address(0));
        assertEq(to.id(), 1337);
        assertBytesEq(to.mintData(), "testing 123");
    }

    function testBatchMintToEOA() public {
        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.batchMint(address(0xBEEF), ids, "");

        assertEq(token.balanceOf(address(0xBEEF), 1337), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1338), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1339), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1340), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1341), 1);
    }

    function testUnsafeMintToEOA() public {
        token.unsafeMint(address(0xBEEF), 1337, "");

        assertEq(token.balanceOf(address(0xBEEF), 1337), 1);
    }

    function testUnsafeMintToERC1155Recipient() public {
        ERC1155BRecipient to = new ERC1155BRecipient();

        token.unsafeMint(address(to), 1337, "testing 123");

        assertEq(token.balanceOf(address(to), 1337), 1);
    }

    function testUnsafeMintToNonERC1155Recipient() public {
        NonERC1155BRecipient to = new NonERC1155BRecipient();

        token.unsafeMint(address(to), 1337, "testing 123");

        assertEq(token.balanceOf(address(to), 1337), 1);
    }

    function testUnsafeBatchMintToEOA() public {
        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.unsafeBatchMint(address(0xBEEF), ids, "");

        assertEq(token.balanceOf(address(0xBEEF), 1337), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1338), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1339), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1340), 1);
        assertEq(token.balanceOf(address(0xBEEF), 1341), 1);
    }

    function testBatchMintToERC1155Recipient() public {
        ERC1155BRecipient to = new ERC1155BRecipient();

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory amounts = new uint256[](5);
        amounts[0] = 1;
        amounts[1] = 1;
        amounts[2] = 1;
        amounts[3] = 1;
        amounts[4] = 1;

        token.batchMint(address(to), ids, "testing 123");

        assertEq(to.batchOperator(), address(this));
        assertEq(to.batchFrom(), address(0));
        assertUintArrayEq(to.batchIds(), ids);
        assertUintArrayEq(to.batchAmounts(), amounts);
        assertBytesEq(to.batchData(), "testing 123");

        assertEq(token.balanceOf(address(to), 1337), 1);
        assertEq(token.balanceOf(address(to), 1338), 1);
        assertEq(token.balanceOf(address(to), 1339), 1);
        assertEq(token.balanceOf(address(to), 1340), 1);
        assertEq(token.balanceOf(address(to), 1341), 1);
    }

    function testBurn() public {
        token.mint(address(0xBEEF), 1337, "");

        token.burn(1337);

        assertEq(token.balanceOf(address(0xBEEF), 1337), 0);
    }

    function testBatchBurn() public {
        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.batchMint(address(0xBEEF), ids, "");

        token.batchBurn(address(0xBEEF), ids);

        assertEq(token.balanceOf(address(0xBEEF), 1337), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1338), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1339), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1340), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1341), 0);
    }

    function testApproveAll() public {
        token.setApprovalForAll(address(0xBEEF), true);

        assertTrue(token.isApprovedForAll(address(this), address(0xBEEF)));
    }

    function testSafeTransferFromToEOA() public {
        ERC1155BUser from = new ERC1155BUser(token);

        token.mint(address(from), 1337, "");

        from.setApprovalForAll(address(this), true);

        token.safeTransferFrom(address(from), address(0xBEEF), 1337, 1, "");

        assertEq(token.balanceOf(address(0xBEEF), 1337), 1);
        assertEq(token.balanceOf(address(from), 1337), 0);
    }

    function testSafeTransferFromToERC1155Recipient() public {
        ERC1155BRecipient to = new ERC1155BRecipient();

        ERC1155BUser from = new ERC1155BUser(token);

        token.mint(address(from), 1337, "");

        from.setApprovalForAll(address(this), true);

        token.safeTransferFrom(address(from), address(to), 1337, 1, "testing 123");

        assertEq(to.operator(), address(this));
        assertEq(to.from(), address(from));
        assertEq(to.id(), 1337);
        assertBytesEq(to.mintData(), "testing 123");

        assertEq(token.balanceOf(address(to), 1337), 1);
        assertEq(token.balanceOf(address(from), 1337), 0);
    }

    function testSafeTransferFromSelf() public {
        token.mint(address(this), 1337, "");

        token.safeTransferFrom(address(this), address(0xBEEF), 1337, 1, "");

        assertEq(token.balanceOf(address(0xBEEF), 1337), 1);
        assertEq(token.balanceOf(address(this), 1337), 0);
    }

    function testSafeBatchTransferFromToEOA() public {
        ERC1155BUser from = new ERC1155BUser(token);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](5);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;
        transferAmounts[4] = 1;

        token.batchMint(address(from), ids, "");

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(address(from), address(0xBEEF), ids, transferAmounts, "");

        assertEq(token.balanceOf(address(from), 1337), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1337), 1);

        assertEq(token.balanceOf(address(from), 1338), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1338), 1);

        assertEq(token.balanceOf(address(from), 1339), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1339), 1);

        assertEq(token.balanceOf(address(from), 1340), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1340), 1);

        assertEq(token.balanceOf(address(from), 1341), 0);
        assertEq(token.balanceOf(address(0xBEEF), 1341), 1);
    }

    function testSafeBatchTransferFromToERC1155Recipient() public {
        ERC1155BUser from = new ERC1155BUser(token);

        ERC1155BRecipient to = new ERC1155BRecipient();

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](5);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;
        transferAmounts[4] = 1;

        token.batchMint(address(from), ids, "");

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(address(from), address(to), ids, transferAmounts, "testing 123");

        assertEq(to.batchOperator(), address(this));
        assertEq(to.batchFrom(), address(from));
        assertUintArrayEq(to.batchIds(), ids);
        assertUintArrayEq(to.batchAmounts(), transferAmounts);
        assertBytesEq(to.batchData(), "testing 123");

        assertEq(token.balanceOf(address(from), 1337), 0);
        assertEq(token.balanceOf(address(to), 1337), 1);

        assertEq(token.balanceOf(address(from), 1338), 0);
        assertEq(token.balanceOf(address(to), 1338), 1);

        assertEq(token.balanceOf(address(from), 1339), 0);
        assertEq(token.balanceOf(address(to), 1339), 1);

        assertEq(token.balanceOf(address(from), 1340), 0);
        assertEq(token.balanceOf(address(to), 1340), 1);

        assertEq(token.balanceOf(address(from), 1341), 0);
        assertEq(token.balanceOf(address(to), 1341), 1);
    }

    function testBatchBalanceOf() public {
        address[] memory tos = new address[](5);
        tos[0] = address(0xBEEF);
        tos[1] = address(0xCAFE);
        tos[2] = address(0xFACE);
        tos[3] = address(0xDEAD);
        tos[4] = address(0xFEED);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.mint(address(0xBEEF), 1337, "");
        token.mint(address(0xCAFE), 1338, "");
        token.mint(address(0xFACE), 1339, "");
        token.mint(address(0xDEAD), 1340, "");
        token.mint(address(0xFEED), 1341, "");

        uint256[] memory balances = token.balanceOfBatch(tos, ids);

        assertEq(balances[0], 1);
        assertEq(balances[1], 1);
        assertEq(balances[2], 1);
        assertEq(balances[3], 1);
        assertEq(balances[4], 1);
    }

    function testFailMintToZero() public {
        token.mint(address(0), 1337, "");
    }

    function testFailMintToNonERC1155Recipient() public {
        token.mint(address(new NonERC1155BRecipient()), 1337, "");
    }

    function testFailMintToRevertingERC1155Recipient() public {
        token.mint(address(new RevertingERC1155Recipient()), 1337, "");
    }

    function testFailMintToWrongReturnDataERC1155Recipient() public {
        token.mint(address(new RevertingERC1155Recipient()), 1337, "");
    }

    function testFailBurnInsufficientBalance() public {
        token.burn(1337);
    }

    function testFailSafeTransferFromInsufficientBalance() public {
        ERC1155BUser from = new ERC1155BUser(token);

        from.setApprovalForAll(address(this), true);

        token.safeTransferFrom(address(from), address(0xBEEF), 1337, 1, "");
    }

    function testFailSafeTransferFromSelfInsufficientBalance() public {
        token.safeTransferFrom(address(this), address(0xBEEF), 1337, 1, "");
    }

    function testFailSafeTransferFromToZero() public {
        token.safeTransferFrom(address(this), address(0), 1337, 1, "");
    }

    function testFailSafeTransferFromToNonERC1155Recipient() public {
        token.mint(address(this), 1337, "");
        token.safeTransferFrom(address(this), address(new NonERC1155BRecipient()), 1337, 1, "");
    }

    function testFailSafeTransferFromToRevertingERC1155Recipient() public {
        token.mint(address(this), 1337, "");
        token.safeTransferFrom(address(this), address(new RevertingERC1155Recipient()), 1337, 1, "");
    }

    function testFailSafeTransferFromToWrongReturnDataERC1155Recipient() public {
        token.mint(address(this), 1337, "");
        token.safeTransferFrom(address(this), address(new WrongReturnDataERC1155BRecipient()), 1337, 1, "");
    }

    function testFailSafeBatchTransferInsufficientBalance() public {
        ERC1155BUser from = new ERC1155BUser(token);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](5);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;
        transferAmounts[4] = 1;

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(address(from), address(0xBEEF), ids, transferAmounts, "");
    }

    function testFailSafeBatchTransferFromToZero() public {
        ERC1155BUser from = new ERC1155BUser(token);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](5);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;
        transferAmounts[4] = 1;

        token.batchMint(address(from), ids, "");

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(address(from), address(0), ids, transferAmounts, "");
    }

    function testFailSafeBatchTransferFromToNonERC1155Recipient() public {
        ERC1155BUser from = new ERC1155BUser(token);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](5);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;
        transferAmounts[4] = 1;

        token.batchMint(address(from), ids, "");

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(address(from), address(new NonERC1155BRecipient()), ids, transferAmounts, "");
    }

    function testFailSafeBatchTransferFromToRevertingERC1155Recipient() public {
        ERC1155BUser from = new ERC1155BUser(token);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](5);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;
        transferAmounts[4] = 1;

        token.batchMint(address(from), ids, "");

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(address(from), address(new RevertingERC1155Recipient()), ids, transferAmounts, "");
    }

    function testFailSafeBatchTransferFromToWrongReturnDataERC1155Recipient() public {
        ERC1155BUser from = new ERC1155BUser(token);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](5);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;
        transferAmounts[4] = 1;

        token.batchMint(address(from), ids, "");

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(
            address(from),
            address(new WrongReturnDataERC1155BRecipient()),
            ids,
            transferAmounts,
            ""
        );
    }

    function testFailSafeBatchTransferFromWithArrayLengthMismatch() public {
        ERC1155BUser from = new ERC1155BUser(token);

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        uint256[] memory transferAmounts = new uint256[](4);
        transferAmounts[0] = 1;
        transferAmounts[1] = 1;
        transferAmounts[2] = 1;
        transferAmounts[3] = 1;

        token.batchMint(address(from), ids, "");

        from.setApprovalForAll(address(this), true);

        token.safeBatchTransferFrom(address(from), address(0xBEEF), ids, transferAmounts, "");
    }

    function testFailBatchMintToZero() public {
        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.batchMint(address(0), ids, "");
    }

    function testFailBatchMintToNonERC1155Recipient() public {
        NonERC1155BRecipient to = new NonERC1155BRecipient();

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.batchMint(address(to), ids, "");
    }

    function testFailBatchMintToRevertingERC1155Recipient() public {
        RevertingERC1155Recipient to = new RevertingERC1155Recipient();

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.batchMint(address(to), ids, "");
    }

    function testFailBatchMintToWrongReturnDataERC1155Recipient() public {
        WrongReturnDataERC1155BRecipient to = new WrongReturnDataERC1155BRecipient();

        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.batchMint(address(to), ids, "");
    }

    function testFailBatchBurnInsufficientBalance() public {
        uint256[] memory ids = new uint256[](5);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;
        ids[4] = 1341;

        token.batchBurn(address(0xBEEF), ids);
    }

    function testFailBalanceOfBatchWithArrayMismatch() public view {
        address[] memory tos = new address[](5);
        tos[0] = address(0xBEEF);
        tos[1] = address(0xCAFE);
        tos[2] = address(0xFACE);
        tos[3] = address(0xDEAD);
        tos[4] = address(0xFEED);

        uint256[] memory ids = new uint256[](4);
        ids[0] = 1337;
        ids[1] = 1338;
        ids[2] = 1339;
        ids[3] = 1340;

        token.balanceOfBatch(tos, ids);
    }
}
