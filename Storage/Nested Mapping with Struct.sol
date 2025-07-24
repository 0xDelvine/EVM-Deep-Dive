// SPDX-License-Identifier: MIT
// @author 0xDelvine
pragma solidity ^0.8.28;

contract StorageLayout {
    uint256 x = 20;
    struct table {
        uint16 a;  // occupies first 16 bits
        uint16 b;  // occupies next 16 bits (same slot as a due to packing)
        uint256 c; // starts at next slot (offset +1 from base)
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
     return uint256(keccak256(abi.encode(key, slotOfMapping)));
     /*
         Storage Explanation:

        - Structs **declared** in Solidity (like `table`) are types and do not occupy
          any storage slot unless **declared and initialised** in the state.

        - So, in this contract:
            uint256 x                     → slot 0
            mapping(...) records          → slot 1
            struct table                  → no slot used (just a type)

        - To access records[key1][key2], we do:
            Step 1: slotA = keccak256(abi.encode(key1, 1))           // outer mapping
            Step 2: slotB = keccak256(abi.encode(key2, slotA))       // inner mapping
            Step 3: fields:
                a and b → packed in slotB       (uint16 + uint16)
                c       → slotB + 1             (next 32-byte word)
        */
    }

}
