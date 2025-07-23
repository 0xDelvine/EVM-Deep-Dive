 ## Memory
 In the EVM, memory is a temporary, mutable area used during function execution to store short-lived data.
 #### Notes on memory: 
- Memory is **cleared only between external calls** (e.g., when calling another contract), not between internal function calls.
- Memory is **not persistent** — it is reset between **transactions and calls**.
- Memory is accessed in 32-byte (256-bit) chunks by default.
- Unlike storage, memory is **not gas-costly** to read but **writing and expanding** memory costs gas ( increasing cost for expansion).

#### Solidity Memory Layout
##### **`0x00`–`0x1F`**  - first memory slot: 
- It is reserved to for use as **Scratch space** ; **temporary data storage** during execution 
- Used for **temporary values**, such as function return values, arguments to external calls, etc.
- Contents are volatile and can be overwritten anytime.
##### **`0x20`–`0x3F`** - second memory slot
- Also part of the **scratch space**, like above.
- Used similarly for temporary values.
##### **`0x40` (Free Memory Pointer)**  - third memory slot
- Stores a pointer to the **next free memory slot**, initially `0x80`.
- Updated as memory is allocated using inline assembly (`mstore`, `mstore8`, etc.) or high-level operations.
- Solidity uses this to ensure new data doesn't overwrite existing memory.

 #####  **`0x60`** - fourth memory slot
- Reserved by Solidity, **intended to be zero**.
- Often used by dynamic types like arrays or `abi.encodePacked()` to store their length or offset.
- Solidity ensures it's cleared before use, but **its contents are not guaranteed to stay empty**—it may temporarily store data depending on context.
- Not a strictly reserved slot like `0x40`, but conventionally left unused unless required.

 ##### **`0x80`** - fifth memory slot
- Actual **free memory** begins here.
- This is where user data, return values, dynamic array contents, encoded ABI data, etc., are stored.

### Summary Table

| Address Range | Purpose                                |
| ------------- | -------------------------------------- |
| `0x00–0x1F`   | Scratch space (temp values)            |
| `0x20–0x3F`   | Scratch space (temp values)            |
| `0x40`        | Free memory pointer (initially `0x80`) |
| `0x60`        | Reserved by Solidity; often zero       |
| `0x80+`       | Start of actual free memory            |

### Example with `abi.encode(uint256 a, uint256 b)`:
Solidity does this in memory:
1. Sets the free memory pointer at `0x40` to point to `0x80`.
2. Writes the encoded values starting at `0x80`:
```python
┌────────────┬─────────────────────────────────────┐
│ 0x80       │ a (32 bytes)                        │
│ 0xA0       │ b (32 bytes)                        │
│ 0xC0       │ (next available slot if needed)     │
└────────────┴─────────────────────────────────────┘
```


Then `mload(0x80)` would give the value of `a`, and so on.
#### After encoding:
- The pointer at `0x40` is updated to `0xC0`.
- If you encode another value later, it will start at `0xC0`.