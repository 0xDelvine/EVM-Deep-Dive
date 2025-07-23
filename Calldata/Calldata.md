## EVM Calldata
**Calldata** is a read-only, non-persistent, and non-modifiable input data area. It contains the data **sent with external function calls** and **constructor arguments**.

### Key Properties:
- **Read-only**: Cannot be modified.
- **Cheapest to read**: Lower gas cost than `memory`.
- **Accessed via**: `calldataload`, `calldatasize`, `calldatacopy`
- **Used for**: Input parameters to functions.


### Structure:
In an external function like `foo(uint256 a, uint256 b)`, when it's called from outside the contract, the EVM packs the input arguments into calldata, which is a byte array.

Here's how the calldata is structured:
````
Function Selector (4 bytes)
Argument a       (32 bytes)
Argument b       (32 bytes)
````

### Example:
```solidity
function foo(uint256 a, uint256 b) external {
    // calldata[4:36]  - The next 32 bytes (from byte 4 to byte 35) represent a (the first uint256 argument)
    // calldata[36:68] - The next 32 bytes (from byte 36 to byte 67) represent b (the second uint256 argument)
}
```

* `msg.data`: raw calldata (`bytes`)
* `msg.sig`: first 4 bytes of `msg.data` (function selector)
* `msg.value`: ETH sent alongside calldata (if any)


### Calldata vs Memory vs Storage:

| Feature     | Calldata       | Memory       | Storage           |
| ----------- | -------------- | ------------ | ----------------- |
| Persistence | Temporary      | Temporary    | Persistent        |
| Mutability  | Immutable      | Mutable      | Mutable           |
| Location    | External input | During call  | Contract DB       |
| Cost        | Cheap to read  | Costly write | Costly read/write |


### Calldata Optimization:

Use `calldata` for:

* External view/pure function arguments (`external view returns`)
* Arrays and structs to avoid memory copying

```solidity
function sum(uint[] calldata nums) external pure returns (uint) {
    uint total;
    for (uint i = 0; i < nums.length; i++) {
        total += nums[i]; // directly read from calldata
    }
    return total;
}
```

### Summary:

* **Calldata is best for read-only inputs**
* **Efficient** for gas savings in external functions
* **Not modifiable** — must be copied to memory if mutation is needed


