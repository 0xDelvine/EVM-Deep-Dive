# Ethereum Virtual Machine (EVM) Deep Dive

This repository contains detailed explanations of the core components of the Ethereum Virtual Machine (EVM). Each section explores a specific aspect of the EVM — such as calldata, memory, opcodes, the stack, and storage — providing both beginner-friendly and technical insights.

## Table of Contents

- [Calldata](./Calldata/Calldata.md)  
  Dive into calldata — the read-only input data passed to smart contracts — and its layout and usage.
  
- [Memory](./Memory/Memory.md)  
  Discover how the temporary memory area works during contract execution and how it differs from storage.
  
- [Opcodes](./Opcodes/Opcodes.md)  
  Learn how individual EVM opcodes function and how they interact with different storage areas.

- [Stack](./Stack/Stack.md)  
  Explore the EVM’s stack-based architecture, including stack depth limits and operation flow.

- [Storage](./Storage/Storage.md)  
  Understand persistent storage in smart contracts, how SLOAD/SSTORE work, and gas implications.

  **Subtopics:**
  - [Uints.sol](./Storage/Uints.sol): Packed and unpacked storage layout of integer types.
  - [Mapping.sol](./Storage/Mapping.sol): Basic mapping structure and storage slot resolution.
  - [Nested Mapping.sol](./Storage/Nested%20Mapping.sol): Storage computation for mappings inside mappings.
  - [Nested Mapping with Struct.sol](./Storage/Nested%20Mapping%20with%20Struct.sol): Understanding slot calculation for nested mappings pointing to structs.


The folders contain:
- Clear explanations with diagrams and analogies.
- Code examples (both Solidity and low-level).
- EVM-centric perspectives.
- Storage interaction scenarios.

## Suggested Usage

- Browse individual folders to focus on one topic at a time.
- Use this as a reference while auditing, building, or studying smart contracts.


Feel free to fork and clone the repo for your own study purposes.
