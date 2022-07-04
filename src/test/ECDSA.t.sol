// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {ECDSA} from "../utils/ECDSA.sol";

contract ECDSATest is DSTestPlus {
    using ECDSA for bytes32;
    using ECDSA for bytes;

    bytes32 constant TEST_MESSAGE = 0x7dbaf558b0a1a5dc7a67202117ab143c1d8605a983e4a743bc06fcc03162dc0d;

    bytes32 constant WRONG_MESSAGE = 0x2d0828dd7c97cff316356da3c16c68ba2316886a0e05ebafb8291939310d51a3;

    address constant SIGNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    address constant V0_SIGNER = 0x2cc1166f6212628A0deEf2B33BEFB2187D35b86c;

    address constant V1_SIGNER = 0x1E318623aB09Fe6de3C9b8672098464Aeda9100E;

    function testRecoverWithInvalidShortSignature() public {
        bytes memory signature = hex"1234";
        assertTrue(this.recover(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithInvalidLongSignature() public {
        // prettier-ignore
        bytes memory signature = hex"01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789";
        assertTrue(this.recover(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithValidSignature() public {
        // prettier-ignore
        bytes memory signature = hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
        assertTrue(this.recover(TEST_MESSAGE.toEthSignedMessageHash(), signature) == SIGNER);
    }

    function testRecoverWithWrongSigner() public {
        // prettier-ignore
        bytes memory signature = hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
        assertTrue(this.recover(WRONG_MESSAGE.toEthSignedMessageHash(), signature) != SIGNER);
    }

    function testRecoverWithInvalidSignature() public {
        // prettier-ignore
        bytes memory signature = hex"332ce75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e01c";
        assertTrue(this.recover(TEST_MESSAGE.toEthSignedMessageHash(), signature) != SIGNER);
    }

    function testRecoverWithV0SignatureWithVersion00() public {
        // prettier-ignore
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be89200";
        assertTrue(this.recover(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV0SignatureWithVersion27() public {
        // prettier-ignore
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be8921b";
        assertTrue(this.recover(TEST_MESSAGE, signature) == V0_SIGNER);
    }

    function testRecoverWithV0SignatureWithWrongVersion() public {
        // prettier-ignore
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be89202";
        assertTrue(this.recover(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV0SignatureWithShortEIP2098Format() public {
        // prettier-ignore
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be892";
        assertTrue(this.recover(TEST_MESSAGE, signature) == V0_SIGNER);
    }

    function testRecoverWithV1SignatureWithVersion01() public {
        // prettier-ignore
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e001";
        assertTrue(this.recover(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV1SignatureWithVersion28() public {
        // prettier-ignore
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e01c";
        assertTrue(this.recover(TEST_MESSAGE, signature) == V1_SIGNER);
    }

    function testRecoverWithV1SignatureWithWrongVersion() public {
        // prettier-ignore
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e002";
        assertTrue(this.recover(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV1SignatureWithShortEIP2098Format() public {
        // prettier-ignore
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feffc8e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e0";
        assertTrue(this.recover(TEST_MESSAGE, signature) == V1_SIGNER);
    }

    function testBytes32ToEthSignedMessageHash() public {
        // prettier-ignore
        assertTrue(TEST_MESSAGE.toEthSignedMessageHash() == bytes32(0x7d768af957ef8cbf6219a37e743d5546d911dae3e46449d8a5810522db2ef65e));
    }

    function testBytesToEthSignedMessageHashShort() public {
        bytes memory message = hex"61626364";
        // prettier-ignore
        assertTrue(message.toEthSignedMessageHash() == bytes32(0xefd0b51a9c4e5f3449f4eeacb195bf48659fbc00d2f4001bf4c088ba0779fb33));
    }

    function testBytesToEthSignedMessageHashEmpty() public {
        bytes memory message = hex"";
        // prettier-ignore
        assertTrue(message.toEthSignedMessageHash() == bytes32(0x5f35dce98ba4fba25530a026ed80b2cecdaa31091ba4958b99b52ea1d068adad));
    }

    function testBytesToEthSignedMessageHashEmptyLong() public {
        // prettier-ignore
        bytes memory message = hex"4142434445464748494a4b4c4d4e4f505152535455565758595a6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383921402324255e262a28292d3d5b5d7b7d";
        // prettier-ignore
        assertTrue(message.toEthSignedMessageHash() == bytes32(0xa46dbedd405cff161b6e80c17c8567597621d9f4c087204201097cb34448e71b));
    }

    function recover(bytes32 hash, bytes calldata signature) external view returns (address) {
        return ECDSA.recover(hash, signature);
    }
}
