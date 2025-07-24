// SPDX-License-Identifier: MIT
// @author 0xDelvine
pragma solidity ^0.8.28;

contract MappingStorage {
    mapping(uint => mapping(uint => uint)) records;

    function set(uint a, uint b, uint value) public {
        records[a][b] = value;
    }

    // Getter function to read storage slots
    function readStorageSlot(uint256 slot) public view returns (bytes32 content) {
        assembly {
            content := sload(slot)
        }
    }

    // Getter function to get the storage slot of a mapping value
     function getMappingSlot(uint slotOfMapping, uint key) public pure returns (uint slot) {
        return uint256(keccak256(abi.encode(key, slotOfMapping)));
    }

    /*
    ─────────────────────────────────────────────────────────────────────────────
    🔐 Storage Layout Explanation for Nested Mapping: records[a][b]
    ─────────────────────────────────────────────────────────────────────────────

    Given:
        mapping(uint => mapping(uint => uint)) public records;

    Solidity stores mappings using the following rule:
        slot = keccak256(abi.encode(key, baseSlot))

    For nested mappings, this is done in two steps:

    STEP 1: Compute the slot of the inner mapping for key `a`
        innerMapSlot = keccak256(abi.encode(a, baseSlot)) 
                     = keccak256(abi.encode(a, 0))  // since `records` is at slot 0

    STEP 2: Compute the slot of the value inside the inner mapping for key `b`
        finalSlot = keccak256(abi.encode(b, innerMapSlot))

    So the actual value of records[a][b] lives at:
        keccak256(abi.encode(b, keccak256(abi.encode(a, 0))))

    Use `readStorageSlot(slot)` to retrieve the value at that location.
    ─────────────────────────────────────────────────────────────────────────────
    */
}

}
