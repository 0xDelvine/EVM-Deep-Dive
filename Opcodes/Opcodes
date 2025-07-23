## Table of Contents

- [Table of Contents](#table-of-contents)
- [Understanding EVM Opcodes and Storage Interactions](#understanding-evm-opcodes-and-storage-interactions)
  - [Key EVM Storage Components](#key-evm-storage-components)
  - [How Opcodes Interact with These Components](#how-opcodes-interact-with-these-components)
    - [1. Stack Opcodes](#1-stack-opcodes)
    - [2. Memory Interaction](#2-memory-interaction)
    - [3. Storage Interaction](#3-storage-interaction)
    - [4. Calldata Interaction](#4-calldata-interaction)
    - [5. Code Interaction](#5-code-interaction)
    - [6. Logs (Events)](#6-logs-events)
  - [Putting It Together: An Execution Snapshot](#putting-it-together-an-execution-snapshot)
  - [Summary Table](#summary-table)
  - [Links to opcode learning resources:](#links-to-opcode-learning-resources)

## Understanding EVM Opcodes and Storage Interactions

The Ethereum Virtual Machine (EVM) executes smart contracts using a series of **opcodes**, which are low-level instructions like `PUSH`, `ADD`, `SSTORE`, `CALLDATALOAD`, and many more. These opcodes interact closely with various **storage components**, each with a distinct role in execution.


### Key EVM Storage Components

| Component    | Scope       | Description                                                                                                          |
| ------------ | ----------- | -------------------------------------------------------------------------------------------------------------------- |
| **Stack**    | Local       | Temporary data used by opcodes (max 1024 items). LIFO. Used for arithmetic, jumps, flow control.                     |
| **Memory**   | Local       | Byte-addressable, temporary during transaction. Cleared after execution. Used for dynamic data like strings, arrays. |
| **Storage**  | Persistent  | Key-value store (256-bit keys/values). Persists across transactions. Each contract has its own storage.              |
| **Calldata** | Read-only   | Input data for external calls. Immutable and cheaper than memory.                                                    |
| **Code**     | Read-only   | The contract's deployed bytecode. Read via `CODESIZE`, `CODECOPY`, etc.                                              |
| **Logs**     | Write-only  | Used to emit events. Not accessible from within contracts.                                                           |

---

### How Opcodes Interact with These Components

Let’s look at the relationship between opcodes and storage components.

#### 1. Stack Opcodes

The stack is the core of EVM execution. Nearly all opcodes **consume** from or **push** to the stack.

```evm
PUSH1 0A       // Stack ← [10]
PUSH1 14       // Stack ← [20, 10]
ADD            // Stack ← [30]   (20 + 10)
```

#### 2. Memory Interaction

Memory is used when dealing with **intermediate data**, especially in complex operations and ABI encoding/decoding.

```evm
MSTORE         // Pops value and memory offset from stack → stores 32 bytes
MLOAD          // Pops memory offset → pushes 32 bytes from memory to stack
```

```evm
PUSH1 0x40     // Memory offset
PUSH1 0xFF     // Value
MSTORE         // Store 0xFF at memory[0x40]
```

#### 3. Storage Interaction

Storage is expensive and persistent. Accessed via:

```evm
SSTORE         // Pops key and value → writes to storage
SLOAD          // Pops key → pushes value from storage
```

```evm
PUSH1 0x00     // Storage slot 0
SLOAD          // Read value at slot 0 → Stack ← [value]
```

#### 4. Calldata Interaction

Used to read input to functions. It’s **read-only** and cheaper than memory.

```evm
CALLDATALOAD   // Pops offset → pushes 32 bytes from calldata
CALLDATASIZE   // Pushes size of calldata
```

```evm
PUSH1 0x04     // Read from calldata offset 4 (skipping the function selector)
CALLDATALOAD   // Load 32 bytes input argument
```

#### 5. Code Interaction

The contract can read its own bytecode:

```evm
CODESIZE       // Pushes size of contract code
CODECOPY       // Copies code into memory
```

Rare but useful in metaprogramming (e.g., cloning patterns).

#### 6. Logs (Events)

Not accessible from within contracts, but emitted using:

```evm
LOG0 - LOG4    // Logs with 0 to 4 topics(indexed data)
```

```evm
LOG1           // Emits a log with 1 topic and data payload (unindexed data)
```

For example this Solidity event:
```solidity
event MyEvent(address indexed user1, address indexed user2, uint256 indexed id);
```
Results in:

LOG4

Topics:
- `topic0`: event signature hash (`keccak256("MyEvent(address,address,uint256)")`)
- `topic1`: `user1`
- `topic2`: `user2`
- `topic3`: `id`


###  Putting It Together: An Execution Snapshot

A typical opcode sequence might look like this:

```evm
PUSH1 0x00        // Stack ← [0x00]   (storage key)
SLOAD             // Stack ← [value at slot 0]
PUSH1 0x01        // Stack ← [0x01, value]
ADD               // Stack ← [value + 1]
PUSH1 0x00        // Stack ← [0x00, value+1]
SSTORE            // Store value+1 into slot 0
```

This is equivalent to: `storage[0] += 1`


### Summary Table

| Opcode                       | Role                | Affects     |
| ---------------------------- | ------------------- | ----------- |
| `PUSH`, `POP`, `DUP`, `SWAP` | Stack management    | Stack       |
| `ADD`, `SUB`, `MUL`, etc.    | Arithmetic          | Stack       |
| `MSTORE`, `MLOAD`            | Memory interaction  | Memory      |
| `SLOAD`, `SSTORE`            | Persistent storage  | Storage     |
| `CALLDATALOAD`               | Function inputs     | Calldata    |
| `LOGx`                       | Emit events         | Logs        |
| `CODESIZE`, `CODECOPY`       | Bytecode operations | Code/Memory |


### Links to opcode learning resources:

[EVM codes](https://www.evm.codes/)

[Solidity Docs](https://docs.soliditylang.org/en/v0.8.28/yul.html#yul)

[Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)
