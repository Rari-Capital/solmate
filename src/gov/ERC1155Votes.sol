// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {ERC1155} from "../tokens/ERC1155.sol";
import {SafeCastLib} from "../utils/SafeCastLib.sol";

/// @notice Compound-like voting extension for ERC1155.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/gov/ERC1155Votes.sol)
abstract contract ERC1155Votes is ERC1155 {
    /*//////////////////////////////////////////////////////////////
                             LIBRARY USAGE
    //////////////////////////////////////////////////////////////*/

    using SafeCastLib for uint256;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate,
        uint256 id
    );

    event DelegateVotesChanged(
        address indexed delegate,
        uint256 indexed id,
        uint256 previousBalance,
        uint256 newBalance
    );

    /*//////////////////////////////////////////////////////////////
                             VOTING STORAGE
    //////////////////////////////////////////////////////////////*/
     
    mapping(address => mapping(uint256 => address)) internal _delegates;

    mapping(address => mapping(uint256 => uint256)) public numCheckpoints;

    mapping(address => mapping(uint256 => mapping(uint256 => Checkpoint))) public checkpoints;
    
    struct Checkpoint {
        uint64 fromTimestamp;
        uint192 votes;
    }

    /*//////////////////////////////////////////////////////////////
                             DELEGATION LOGIC
    //////////////////////////////////////////////////////////////*/

    function delegates(address account, uint256 id) public view virtual returns (address) {
        address current = _delegates[account][id];

        return current == address(0) ? account : current;
    }

    function getCurrentVotes(address account, uint256 id) public view virtual returns (uint256) {
        // Won't underflow because decrement only occurs if positive `nCheckpoints`.
        unchecked {
            uint256 nCheckpoints = numCheckpoints[account][id];

            return
                nCheckpoints != 0
                    ? checkpoints[account][id][nCheckpoints - 1].votes
                    : 0;
        }
    }

    function getPriorVotes(
        address account, 
        uint256 id,
        uint256 timestamp
    )
        public
        view
        virtual
        returns (uint256)
    {
        require(block.timestamp > timestamp, "UNDETERMINED");

        uint256 nCheckpoints = numCheckpoints[account][id];

        if (nCheckpoints == 0) return 0;

        // Won't underflow because decrement only occurs if positive `nCheckpoints`.
        unchecked {
            // First check most recent balance.
            if (
                checkpoints[account][id][nCheckpoints - 1].fromTimestamp <=
                timestamp
            ) return checkpoints[account][id][nCheckpoints - 1].votes;

            // Next check implicit zero balance.
            if (checkpoints[account][id][0].fromTimestamp > timestamp) return 0;

            uint256 lower;

            uint256 upper = nCheckpoints - 1;

            while (upper > lower) {
                uint256 center = upper - (upper - lower) / 2;

                Checkpoint memory cp = checkpoints[account][id][center];

                if (cp.fromTimestamp == timestamp) {
                    return cp.votes;
                } else if (cp.fromTimestamp < timestamp) {
                    lower = center;
                } else {
                    upper = center - 1;
                }
            }

            return checkpoints[account][id][lower].votes;
        }
    }

    function delegate(address delegatee, uint256 id) public virtual {
        address currentDelegate = delegates(msg.sender, id);

        _delegates[msg.sender][id] = delegatee;

        emit DelegateChanged(msg.sender, currentDelegate, delegatee, id);

        _moveDelegates(currentDelegate, delegatee, id, balanceOf[msg.sender][id]);
    }

    function _moveDelegates(
        address srcRep,
        address dstRep,
        uint256 id,
        uint256 amount
    ) internal virtual {
        if (srcRep != dstRep && amount != 0) {
            if (srcRep != address(0)) {
                uint256 srcRepNum = numCheckpoints[srcRep][id];

                uint256 srcRepOld = srcRepNum != 0
                    ? checkpoints[srcRep][id][srcRepNum - 1].votes
                    : 0;

                _writeCheckpoint(srcRep, id, srcRepNum, srcRepOld, srcRepOld - amount);
            }

            if (dstRep != address(0)) {
                uint256 dstRepNum = numCheckpoints[dstRep][id];

                uint256 dstRepOld = dstRepNum != 0
                    ? checkpoints[dstRep][id][dstRepNum - 1].votes
                    : 0;

                _writeCheckpoint(dstRep, id, dstRepNum, dstRepOld, dstRepOld + amount);
            }
        }
    }

    function _writeCheckpoint(
        address delegatee,
        uint256 id,
        uint256 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    ) internal virtual {
        unchecked {
            uint64 timestamp = block.timestamp.safeCastTo64();

            // Won't underflow because decrement only occurs if positive `nCheckpoints`.
            if (
                nCheckpoints != 0 &&
                checkpoints[delegatee][id][nCheckpoints - 1].fromTimestamp ==
                timestamp
            ) {
                checkpoints[delegatee][id][nCheckpoints - 1].votes = newVotes.safeCastTo192();
            } else {
                checkpoints[delegatee][id][nCheckpoints] = Checkpoint(
                    timestamp,
                    newVotes.safeCastTo192()
                );

                // Won't realistically overflow.
                ++numCheckpoints[delegatee][id];
            }
        }

        emit DelegateVotesChanged(delegatee, id, oldVotes, newVotes);
    }
}
