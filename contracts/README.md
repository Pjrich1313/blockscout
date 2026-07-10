# Pamela's Robin Hood Smart Contract

## Overview

This is a smart contract implementation of the **Pamela's Robin Hood** token, an ERC-20 compliant token with a built-in redistribution mechanism for community funds.

**Based on:** blockscout/blockscout commit 731015d88d7e73623f2a3c097e241bc82b04ea7a  
**Timestamp (UTC):** 2026-07-03T14:34:44Z  
**Timestamp (Central Time):** 2026-07-03T09:34:44 CDT  
**Created by:** Pamela  
**Repository:** Pjrich1313/blockscout  
**Branch:** pamela-robin-hood-contract

---

## Features

### Core ERC-20 Functionality
- **Token Name:** Pamela's Robin Hood
- **Token Symbol:** ROBIN
- **Decimals:** 18
- Standard ERC-20 interface for transfers, approvals, and allowances

### Robin Hood Redistribution Mechanism
- **Automatic Redistribution:** 2% of each transaction is automatically directed to a community fund
- **Community Fund Management:** Owner can distribute community funds to beneficiaries
- **Contribution Tracking:** Tracks individual contributions for transparency and governance

### Contract Management Features
- **Pausable Mechanism:** Owner can pause/unpause contract for emergency situations
- **Ownership Transfer:** Ability to transfer ownership to a new address
- **Access Control:** Owner-only functions protected by modifier
- **Zero Address Prevention:** Built-in checks to prevent transfers to zero address

---

## Contract Architecture

### State Variables

| Variable | Type | Description |
|----------|------|-------------|
| `name` | string | Token name ("Pamela's Robin Hood") |
| `symbol` | string | Token symbol ("ROBIN") |
| `decimals` | uint8 | Decimal places (18) |
| `_totalSupply` | uint256 | Total token supply |
| `_balances` | mapping | Account token balances |
| `_allowances` | mapping | Allowance amounts for transferFrom |
| `owner` | address | Contract owner address |
| `paused` | bool | Pause state flag |
| `communityFund` | uint256 | Community fund balance |
| `redistributionPercentage` | uint256 | Redistribution percentage (2%) |
| `contributions` | mapping | Individual contribution tracking |

### Core Functions

#### Transfer Functions
- **`transfer(address recipient, uint256 amount)`**
  - Transfers tokens to recipient with automatic 2% redistribution
  - Emits Transfer and Redistribution events
  - Returns bool

- **`transferFrom(address sender, address recipient, uint256 amount)`**
  - Transfers tokens using allowance mechanism
  - Applies 2% redistribution to community fund
  - Requires sufficient allowance
  - Returns bool

- **`approve(address spender, uint256 amount)`**
  - Approves spender to transfer on behalf of owner
  - Emits Approval event
  - Returns bool

#### View Functions
- **`balanceOf(address account)`** - Returns account token balance
- **`allowance(address owner, address spender)`** - Returns allowance amount
- **`totalSupply()`** - Returns total token supply
- **`getCommunityFund()`** - Returns current community fund balance

#### Community Fund Management
- **`distributeFromCommunityFund(address[] calldata beneficiaries, uint256[] calldata amounts)`**
  - Distributes funds from community fund to multiple beneficiaries
  - Only callable by owner
  - Requires matching array lengths
  - Validates sufficient fund balance

#### Contract Management
- **`pause()`** - Pauses all token transfers (owner only)
- **`unpause()`** - Resumes token transfers (owner only)
- **`transferOwnership(address newOwner)`** - Transfers contract ownership (owner only)

---

## Events

| Event | Parameters | Description |
|-------|-----------|-------------|
| `Transfer` | address from, address to, uint256 value | Token transfer event |
| `Approval` | address owner, address spender, uint256 value | Approval event |
| `Redistribution` | uint256 amount, uint256 timestamp | Community fund redistribution |
| `OwnershipTransferred` | address previousOwner, address newOwner | Ownership change |
| `Paused` | - | Contract paused |
| `Unpaused` | - | Contract resumed |

---

## Usage Examples

### Deployment
```solidity
// Deploy with initial supply of 1,000,000 tokens
PamelasRobinHood token = new PamelasRobinHood(1000000);
// Initial supply: 1,000,000 * 10^18 wei
```

### Transfer with Automatic Redistribution
```solidity
// Transfer 100 tokens
// 2 tokens (2%) → community fund
// 98 tokens → recipient
token.transfer(recipientAddress, 100 * 10**18);
```

### Approve and TransferFrom
```solidity
// Owner approves spender for 500 tokens
token.approve(spenderAddress, 500 * 10**18);

// Spender transfers 100 tokens (2% redistribution applies)
token.transferFrom(ownerAddress, recipientAddress, 100 * 10**18);
```

### Distribute Community Funds
```solidity
address[] memory beneficiaries = [
    0x742d35Cc6634C0532925a3b844Bc7e7595f42471,
    0x8626f6940E2eb28930DF686c97afe7d4Eac8b76B,
    0x3f5ce5fbFe3E9af3971dD833D26bA9ad5A1ff337
];

uint256[] memory amounts = [
    100 * 10**18,
    150 * 10**18,
    75 * 10**18
];

token.distributeFromCommunityFund(beneficiaries, amounts);
```

### Emergency Pause/Unpause
```solidity
// Pause transfers during emergency
token.pause();

// Resume transfers after resolution
token.unpause();
```

### Transfer Ownership
```solidity
// Transfer ownership to new address
token.transferOwnership(newOwnerAddress);
```

---

## Security Features

### Built-in Protections
1. **Reentrancy Prevention:** Uses checks-effects-interactions pattern
2. **Overflow/Underflow Protection:** Solidity 0.8.0+ built-in protection
3. **Access Control:** Owner-only functions protected by `onlyOwner` modifier
4. **Pause Mechanism:** Emergency pause available for all transfers
5. **Zero Address Checks:** Prevents transfers to zero address
6. **Array Length Validation:** Ensures matching array lengths in batch operations

### Audit Recommendations
- Contract should be audited by professional security firm before mainnet deployment
- Consider multi-signature owner for production use
- Implement timelock for ownership changes
- Consider adding whitelist/blacklist functionality if needed

---

## Deployment Information

### Contract Metadata
- **Commit Reference:** 731015d88d7e73623f2a3c097e241bc82b04ea7a
- **Commit Date (UTC):** 2026-07-03T14:34:44Z
- **Commit Date (Central Time):** 2026-07-03T09:34:44 CDT
- **Solidity Version:** ^0.8.0
- **License:** MIT (SPDX-License-Identifier: MIT)
- **Author:** Pamela
- **Project:** Blockscout Integration

### File Locations
- **Contract File:** `contracts/PamelasRobinHood.sol`
- **Documentation:** `contracts/README.md`
- **Repository:** https://github.com/Pjrich1313/blockscout
- **Branch:** pamela-robin-hood-contract

### Network Deployment
This contract can be deployed on any EVM-compatible blockchain:
- Ethereum Mainnet
- Ethereum Testnet (Sepolia, Goerli)
- Polygon Network
- Binance Smart Chain
- Other EVM chains

---

## Testing Recommendations

### Unit Tests
- [ ] Test ERC-20 standard compliance
- [ ] Verify 2% redistribution calculation
- [ ] Test community fund distribution
- [ ] Test pause/unpause functionality
- [ ] Test ownership transfer
- [ ] Test access control (onlyOwner modifiers)
- [ ] Test edge cases (zero amounts, max uint256, etc.)

### Integration Tests
- [ ] Test with Blockscout explorer
- [ ] Test transaction tracking
- [ ] Verify event logs
- [ ] Test gas optimization

---

## Version History

### Version 1.0.0 (2026-07-03 @ 09:34:44 CDT)
- Initial deployment
- ERC-20 standard implementation
- 2% redistribution mechanism
- Community fund management
- Pause/unpause functionality
- Ownership transfer capability

---

## Support & Documentation

For more information about:
- **Blockscout:** Visit [docs.blockscout.com](http://docs.blockscout.com)
- **ERC-20 Standard:** See [EIP-20 Specification](https://eips.ethereum.org/EIPS/eip-20)
- **Solidity:** Visit [solidity.readthedocs.io](https://solidity.readthedocs.io)

---

**Last Updated:** 2026-07-03 @ 09:34:44 CDT  
**Status:** ✅ Active and Ready for Deployment
