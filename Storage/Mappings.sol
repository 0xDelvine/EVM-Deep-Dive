// SPDX-License-Identifier: MIT
// @author 0xDelvine
pragma solidity ^0.8.28;

contract MappingStorage { 
    uint256 x = 20;
    mapping(uint => uint) records;

    function set(uint key, uint value) public {
        records[key] = value;
    }

    // Getter function to read storage slots
    function readStorageSlot(uint256 slot) public view returns (bytes32 content) {
        assembly {
            content := sload(slot)
        }
    }

    // Getter function to get the storage slot of a mapping value
    function getMappingSlot(uint slotOfMapping, uint key) public pure returns (uint slot) {
        // slotOfMapping: the slot where the mapping is stored (e.g. slot 1)
        // key: the key you want to use to look up the value
        // slot: the slot where the value for the given key is stored
        return uint256(keccak256(abi.encode(key, slotOfMapping)));
    }
}
