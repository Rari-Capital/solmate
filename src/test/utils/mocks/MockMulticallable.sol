// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "../../../utils/Multicallable.sol";

contract MockMulticallable is Multicallable {
    error CustomError();

    struct Tuple {
        uint256 a;
        uint256 b;
    }

    function revertsWithString(string memory e) external pure {
        revert(e);
    }

    function revertsWithCustomError() external pure {
        revert CustomError();
    }

    function revertsWithNothing() external pure {
        revert();
    }

    function returnsTuple(uint256 a, uint256 b) external pure returns (Tuple memory tuple) {
        tuple = Tuple({a: a, b: b});
    }

    function returnsString(string calldata s) external pure returns (string memory) {
        return s;
    }

    uint256 public paid;

    function pay() external payable {
        paid += msg.value;
    }

    function returnsSender() external view returns (address) {
        return msg.sender;
    }

    function multicallOriginal(bytes[] calldata data) public payable returns (bytes[] memory results) {
        unchecked {
            results = new bytes[](data.length);
            for (uint256 i = 0; i < data.length; i++) {
                (bool success, bytes memory result) = address(this).delegatecall(data[i]);
                if (!success) {
                    // Next 5 lines from https://ethereum.stackexchange.com/a/83577
                    if (result.length < 68) revert();
                    assembly {
                        result := add(result, 0x04)
                    }
                    revert(abi.decode(result, (string)));
                }
                results[i] = result;
            }
        }
    }
}
