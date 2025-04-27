# Blockchain

This repository showcases implementations of various blockchain-based systems, demonstrating skills in smart contract development, decentralized applications, and automated market makers.

## Projects

### 1. Smart Contract Fundamentals
- **Hello World Contract**: Basic Solidity contract with greeting functionality
- **Contract Interaction**: Demonstrates calling one contract from another using interfaces
- Features:
  - State variable management
  - Function visibility control
  - Interface implementation
  - Cross-contract communication

### 2. Decentralized Rock-Paper-Scissors Game
- Fully on-chain implementation of the classic game
- Features:
  - Commit-reveal scheme for fair play
  - Timeout mechanisms
  - Multi-round gameplay
  - Winner-takes-all prize distribution
  - 5% platform fee structure
  - Event logging for all game actions

### 3. Automated Market Maker (AMM) Implementation
- Decentralized exchange prototype inspired by Uniswap
- Features:
  - ERC-20 token implementation with approvals
  - Constant product formula (x*y=k) for pricing
  - Slippage protection
  - Front-running prevention with transaction deadlines
  - Allowance management system
  - Token swap functionality

## Technical Highlights

- **Smart Contract Development**: Solidity contracts deployed on Ethereum testnet
- **Security Patterns**: Commit-reveal scheme, input validation, reentrancy protection
- **Decentralized Finance**: AMM design with liquidity pools
- **Game Theory**: Fair gameplay mechanisms for decentralized environments
- **Gas Optimization**: Efficient state management and storage patterns

## Development Tools

- Solidity (0.7.0-0.9.0)
- Remix IDE
- Ethereum Sepolia Testnet
- MetaMask Wallet
- OpenZeppelin patterns (conceptual)
