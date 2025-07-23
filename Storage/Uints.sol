// SPDX-License-Identifier: MIT
// @author 0xDelvine
pragma solidity ^0.8.28;

contract StorageLayout {
    uint256 x;
    uint128 y;
    uint128 z;

    function set(uint256 X, uint128 Y, uint128 Z) public {
        x = X;
        y = Y;
        z = Z;
    }

  // Getter function to read storage slots
    function readStorageSlot(uint256 i) public view returns (bytes32 content) {
        assembly {
            content := sload(i)
        }
    }
}
