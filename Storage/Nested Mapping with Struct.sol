// SPDX-License-Identifier: MIT
// @author 0xDelvine
pragma solidity ^0.8.28;

contract StorageLayout {
    uint256 x = 20;
    struct table { 
        uint16 a;
        uint16 b;
        uint256 c;
         }

    mapping(uint => mapping(uint => table)) records;

    function setC(uint key1, uint key2, uint value) public {
       records[key1][key2].c = value;
    }

   // Getter function to read storage slots
    function readStorageSlot(uint256 i) public view returns (bytes32 content) {
        assembly {
            content := sload(i)
        }
    }

    // Getter function to get the storage slot of a nested mapping inside a struct
function getMappingSlot(uint slotOfMapping, uint key) public pure returns (uint slot) {
    // To locate a nested mapping value inside a struct, we compute storage slots step by step:
    // First, compute keccak256(abi.encode(key1, slotOfMapping)) to find the slot for records[key1].
    // Then, hash that with the second key: keccak256(abi.encode(key2, <previous_hash>)) to find the base slot of the struct.
    // Add offset: since a and b are uint16s (packed), they occupy one base slot, say x: c lives at base Slot x + 1
    return uint256(keccak256(abi.encode(key, slotOfMapping)));
}

}
