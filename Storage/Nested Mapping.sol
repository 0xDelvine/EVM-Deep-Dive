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
    // Mapping storage is computed as keccak256(abi.encode(key, slotOfMapping)).
    // Although the mapping slot (e.g., slot 1) itself holds no value (typically just zero),
    // it acts as a seed in the hashing process to deterministically derive a unique slot for each key.
    // This prevents storage collisions and distributes mapping values across pseudo-random slots.
    return uint256(keccak256(abi.encode(key, slotOfMapping)));
}

}
