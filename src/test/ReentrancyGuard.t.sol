// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import {TestPlus} from "./utils/TestPlus.sol";

import {ReentrancyGuard} from "../utils/ReentrancyGuard.sol";

contract RiskyContract is ReentrancyGuard {
    uint256 public enterTimes;

    function unprotectedCall() public {
        enterTimes++;

        if (enterTimes > 1) return;

        protectedCall();
    }

    function protectedCall() public nonReentrant {
        enterTimes++;

        if (enterTimes > 1) return;

        protectedCall();
    }

    function overprotectedCall() public nonReentrant {}
}

contract ReentrancyGuardTest is TestPlus {
    RiskyContract riskyContract;

    function setUp() public {
        riskyContract = new RiskyContract();
    }

    function invariantReentrancyStatusAlways1() public {
        assertEq(uint256(vm.load(address(riskyContract), 0)), 1);
    }

    function testUnprotectedCall() public {
        riskyContract.unprotectedCall();

        assertEq(riskyContract.enterTimes(), 2);
    }

    function testProtectedCall() public {
        vm.expectRevert("REENTRANCY");
        riskyContract.protectedCall();
    }

    function testNoReentrancy() public {
        riskyContract.overprotectedCall();
    }
}
