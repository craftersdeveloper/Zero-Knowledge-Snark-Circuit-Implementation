# Zkevm Snark Implementation - Metacrafters Project 

### Project Objective: zkSNARK Circuit Design for Logical Gate Verification

The objective of this project is to design a zkSNARK (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge) circuit using the Circom programming language to implement a logical operation. The circuit will represent a logical gate that takes two binary inputs, A and B, and produces an output of 0. Specifically, you will:

![circuit-picture](https://github.com/user-attachments/assets/263f0191-4689-4cb2-8242-ec2e130856f6)


1. Implement a logical gate in Circom that evaluates the inputs A (0) and B (1) to yield an output of 0.
2. Generate zkSNARK proofs that demonstrate knowledge of these specific inputs (A = 0, B = 1).
3. Deploy an on-chain verifier using smart contracts (on the Polygon Amoy) to validate the zkSNARK proofs.
4. Ensure that the on-chain verifier correctly validates the zero-knowledge proof without revealing the inputs (A and B).

### Introduction To Zkevm Snarks 

<img align="center" src="https://miro.medium.com/v2/resize:fit:720/format:webp/1*y1Bpyr-sY7V5Y1H2mcVv8w.png">

zkEVM SNARKs combine the concepts of Zero-Knowledge Succinct Non-Interactive Arguments of Knowledge (zkSNARKs) with the **Ethereum Virtual Machine (EVM).** They are cryptographic proofs designed to verify the execution of Ethereum smart contracts and transactions without needing to re-execute the operations on-chain.

### What zkEVM SNARKs Do:

**Efficient Verification:** zkEVM SNARKs allow the Ethereum blockchain to verify the execution of complex smart contract logic and transactions without executing the full computation on-chain.
**Scalability:** By offloading execution from Ethereum’s main network to a zkEVM, it reduces gas costs and network congestion, thereby improving scalability.
**Privacy:** zkEVM SNARKs preserve user privacy, as the data involved in transactions can be proven valid without being revealed publicly.

### Prerequisites for zkSNARK Circuit Deployment Using Solidity, Circom, Hardhat, and Amoy Tokens


1. **Solidity**: A programming language used to write smart contracts on Ethereum-compatible blockchains.
   - Install Solidity via npm:  
     ```bash
     npm install -g solc
     ```

2. **Circom**: A domain-specific language for designing zero-knowledge circuits.
   - Install Circom following the official guide:  
     ```bash
     git clone https://github.com/iden3/circom  
     cd circom  
     cargo build --release
     ```

3. **Hardhat**: A development environment to compile, deploy, test, and debug smart contracts on Ethereum-compatible networks.
   - Install Hardhat via npm:  
     ```bash
     npm install --save-dev hardhat
     ```

4. **Amoy Tokens**: Tokens required for deploying smart contracts to the Amoy network (testnet or mainnet). Ensure you have access to Amoy tokens and that your wallet is configured for the network.

### Installation & Execution Steps

1. **Clone the Project Repository**:
   Clone the repository containing the smart contracts and circuit setup.
   ```bash
   git clone repository_link
   cd project_directory
   ```

2. **Install Dependencies**:
   Use `npm` to install the necessary dependencies for the project.
   ```bash
   npm install
   ```

3. **Compile Circom Circuit**:
   Use Hardhat to compile the zkSNARK circuit defined in Circom.
   ```bash
   npx hardhat circom
   ```

4. **Deploy Smart Contract to the Amoy Network**:
   Execute the deployment script and deploy your smart contract verifier on the Amoy network.
   ```bash
   npx hardhat run scripts/deploy.ts --network amoy
   ```

### Zksnarks Circuit Explanation 

```circom
pragma circom 2.0.0;

/*This circuit template checks that c is the multiplication of a and b.*/  

template Multiplier2 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;
   signal x;  
   signal y;  
   signal output c;

   //component
   component andGate = AND();
   component notGate = NOT();
   component orGate = OR();

   // Logic From AND to singals
   andGate.a <== a;
   andGate.b <== b;
   x <== andGate.out;

   // Logic From Signals to Not Gate 
   notGate.in <== b;
   y <== notGate.out;

   //Logic From Not gate to Output C
   orGate.a <== x;
   orGate.b <== y;
   c <== orGate.out;

}

template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;
}

template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

component main = Multiplier2();
```
This code is written in **Circom**, a domain-specific language for designing zero-knowledge circuits. It defines a simple circuit template called `Multiplier2` that uses logical gates (AND, NOT, and OR) to evaluate a result based on the multiplication of two inputs. Let’s break it down step by step:

### 1. **Pragma Directive**:
```solidity
pragma circom 2.0.0;
```
- This line specifies that the circuit is written for Circom version 2.0.0, which is essential for compatibility with the right version of the Circom compiler.

### 2. **Template `Multiplier2`**:
This is the main circuit template that is defined to take two inputs, `a` and `b`, and compute a final output `c`. However, instead of performing a direct multiplication, it uses logical gates (AND, NOT, OR) to derive the output.

#### **Signal Declarations**:
```circom
signal input a;
signal input b;
signal x;  
signal y;  
signal output c;
```
- `signal input a;` and `signal input b;` are the two inputs to the circuit.
- `signal x;` and `signal y;` are intermediate signals (internal values that will be computed).
- `signal output c;` is the final output of the circuit.

#### **Component Instantiation**:
```circom
component andGate = AND();
component notGate = NOT();
component orGate = OR();
```
- Here, three different components are created: an AND gate (`andGate`), a NOT gate (`notGate`), and an OR gate (`orGate`). These components represent logical gates that will perform the core computations inside the circuit.

#### **Logical Operations**:

1. **AND Gate**:
   ```circom
   andGate.a <== a;
   andGate.b <== b;
   x <== andGate.out;
   ```
   - The inputs `a` and `b` are passed to the `andGate` (which represents the AND operation). 
   - The result of the AND gate operation (stored in `andGate.out`) is assigned to signal `x`.

2. **NOT Gate**:
   ```circom
   notGate.in <== b;
   y <== notGate.out;
   ```
   - The input `b` is passed to the `notGate` (which represents the NOT operation).
   - The result of the NOT gate is stored in signal `y`.

3. **OR Gate**:
   ```circom
   orGate.a <== x;
   orGate.b <== y;
   c <== orGate.out;
   ```
   - The output `x` from the AND gate and the output `y` from the NOT gate are passed to the `orGate` (which represents the OR operation).
   - The result of the OR gate (`orGate.out`) is assigned to the final output signal `c`.

### 3. **AND Gate Template**:
```circom
template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}
```
- The AND gate multiplies the inputs `a` and `b`. This is a basic AND operation, as multiplication in boolean logic between two binary inputs (0 or 1) will give the same result as the AND operation:
   - 0 * 0 = 0
   - 0 * 1 = 0
   - 1 * 0 = 0
   - 1 * 1 = 1

### 4. **NOT Gate Template**:
```circom
template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;
}
```
- The NOT gate inverts the input. For binary inputs:
   - If `in = 0`, the output is `1 + 0 - 2*0 = 1`.
   - If `in = 1`, the output is `1 + 1 - 2*1 = 0`.

### 5. **OR Gate Template**:
```circom
template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}
```
- The OR gate performs the logical OR operation. The formula used here gives the correct OR result:
   - 0 + 0 - 0 * 0 = 0
   - 0 + 1 - 0 * 1 = 1
   - 1 + 0 - 1 * 0 = 1
   - 1 + 1 - 1 * 1 = 1

### 6. **Main Component**:
```circom
component main = Multiplier2();
```
- The `Multiplier2` circuit is instantiated as the main circuit component. This will allow the circuit to process the inputs and generate the final output using the logic described above.
