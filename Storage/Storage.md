## Table of Contents
- [Table of Contents](#table-of-contents)
  - [What is storage in the EVM?](#what-is-storage-in-the-evm)
  - [Why is storing data in storage expensive?](#why-is-storing-data-in-storage-expensive)
  - [So how is data stored in the EVM's storage?](#so-how-is-data-stored-in-the-evms-storage)
  - [Tips to help save gas:](#tips-to-help-save-gas)
  - [Conclusion](#conclusion)


### What is storage in the EVM?
- Data that is stored persistently and can be accessed and modified by future transactions

### Why is storing data in storage expensive? 
- Since ethereum is decentralized, every full node stores a copy of the entire state (contract storage), and unlike memory or stack, storage values **persist across transactions and blocks**
  
### So how is data stored in the EVM's storage?

Let’s look at an example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract StorageLayout {
    uint256 x = 5; // 32 bytes
    address ab = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB; // 20 bytes
    uint32 y = 7;  // 4 bytes
    uint32 z = 6;  // 4 bytes
    uint32 a = 9;  // 4 bytes
    uint64 b = 125; // 8 bytes
}
```
**What Solidity Will Do**:
Solidity packs **small variables into one storage slot (32 bytes)** as long as:
- They’re declared **consecutively**
- They **fit** within that storage slot
- They are **compatible** (like `uintXX`, `address`, etc.)

Slot 1:
```
Slot 1 contents (in hex):
0000009000000060000000778731d3ca6b7e34ac0f824c42a7cc18a495cabab
│        │        │        └─ address (20 bytes / 40 hex chars)
│        │        └─ y = 7 (00000007)
│        └─ z = 6 (00000006)
└─ a = 9 (00000009)
```

Slot 2:
```
000000000000000000000000000000000000000000000000000000000000007d 
[b = 125] (uint64, 8 bytes) — padded to full 32 bytes
```


### Tips to help save gas:
1. Don't store if you don't have to: 
   
   If you never use it again, don't store it; Use events if you  never have to access that data again:
		e.g using an event to show a log of a mapping instead of using a mapping : 
		In this example, we ended up saving 25,000 gas!
    ```solidity
		mapping(address => uint256[]) transfers; // any function calling it uses more gas to sload(~ 61000 gas)
		event Transfer(address indexed sender, address indexed receiver, uint256 amount); //uses significantly less amounts of gas(~ 36000 gas)
    ```

2. Use constant and immutable when possible
   
    These avoid SLOADs entirely, saving gas every time a function reads it:

    ``` solidity 
	    uint256 public duration = 7; // ~2500 gas
	    uint256 public constant DURATION = 7; // ~450 gas
    ```

3. Minimize storage reads/writes inside functions:
   
    Copy the storage value into a local variable, operate on it, then store the final result.

	E.g: In the example below, we end up referencing storage only twice!
    ``` solidity
    uint256 public s_index;
    function updateIndex(uint256 index) public returns (uint256){
    uint256 currentIndex = s_index;
    require (currentIndex != 0);
    if (currentIndex < index){
        currentIndex += index;
        }
    else if (currentIndex > index){
        currentIndex -=index;
        }
    s_index = currentIndex;
    return currentIndex;
    }
    ```

4. Pack and order your storage variables:

	Solidity packs variables in the same slot if:

	i.   They are declared consecutively.

	ii.  They fit within that storage slot.

	iii. The types are compatible for packing.

   Now that we know how solidity packs state variables, we can use the example below to show gas wastage and optimization by packing them:

    The example below ends up using 5 storage slots
    ```solidity
    contract BadStorageLayout {
        uint128 valueA;         // occupies slot 0 (16 bytes, 16 bytes wasted)
        uint256 valueB;         // occupies slot 1 (32 bytes)
        uint64 valueC;          // occupies slot 2 (8 bytes, 24 bytes wasted)
        bytes32 valueD;         // occupies slot 3 (32 bytes)
        uint16 valueE;          // occupies slot 4 (2 bytes, 30 bytes wasted)
    }       
    ```
    Optimized version:
    ```solidity
    contract GoodStorageLayout {
        uint256 valueB;         // occupies slot 0 (32 bytes)
        bytes32 valueD;         // occupies slot 1 (32 bytes)
        uint128 valueA;         // occupies slot 2 (16 bytes)
        uint64 valueC;          // occupies slot 2 (8 bytes, packed after valueA)
        uint16 valueE;          // occupies slot 2 (2 bytes, packed after valueC)
                                // 6 bytes still left unused in slot 2
    }
    ```
    Where:
    Only 3 **slots used instead of 5**. Fewer slots = less gas.

    This reduces the number of storage slots used — and since **storage operations (SSTORE, SLOAD)** are among the **most expensive** operations in the EVM, fewer slots directly mean lower gas costs.


### Conclusion

Optimizing storage layout and access patterns is one of the most effective ways to reduce gas costs in Solidity. Be intentional about variable ordering, storage writes, and using constants where applicable. Even small tweaks can lead to meaningful savings, especially at scale.






