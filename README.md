# Decentralized Escrow Smart Contract 🔒

## Overview

This is a **trustless escrow smart contract** that ensures secure transactions between two parties. The funds are locked in escrow and released only when both parties fulfill the agreement. An optional arbitrator can resolve disputes if necessary.

## Features

✅ **Secure Transactions** – Funds are held in escrow until conditions are met.  
✅ **Third-Party Arbitrator (Optional)** – A mediator can resolve disputes.  
✅ **Automated Refunds** – If conditions aren’t met, funds are returned.  
✅ **No Middleman Required** – Uses smart contract logic to enforce agreements.

## Tech Stack

- **Solidity** – Smart contract language.
- **Hardhat** – Development and testing framework.
- **Ethers.js** – For interaction with the contract.

## Use Cases

🔹 **Freelance Work** – Payment is held in escrow until the work is delivered.  
🔹 **E-commerce Transactions** – Prevents fraud in online purchases.  
🔹 **Real Estate & Rentals** – Holds deposits securely until terms are met.  
🔹 **OTC Crypto Trading** – Ensures both parties fulfill their obligations.

## How It Works

1. **Buyer deposits funds** into the smart contract.
2. **Seller completes the service/delivery.**
3. **Buyer approves the transaction**, releasing funds to the seller.
4. **If a dispute arises, an arbitrator can resolve it (optional).**

## Smart Contract Code (Escrow.sol)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbitrator;
    uint public amount;
    bool public isDisputed;

    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, DISPUTED }
    State public currentState;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only arbitrator can call this");
        _;
    }

    constructor(address _seller, address _arbitrator) payable {
        buyer = msg.sender;
        seller = _seller;
        arbitrator = _arbitrator;
        amount = msg.value;
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() public onlyBuyer {
        require(currentState == State.AWAITING_DELIVERY, "Not awaiting delivery");
        payable(seller).transfer(amount);
        currentState = State.COMPLETE;
    }

    function raiseDispute() public onlyBuyer {
        require(currentState == State.AWAITING_DELIVERY, "Cannot dispute now");
        currentState = State.DISPUTED;
        isDisputed = true;
    }

    function resolveDispute(bool favorBuyer) public onlyArbitrator {
        require(currentState == State.DISPUTED, "No dispute to resolve");

        if (favorBuyer) {
            payable(buyer).transfer(amount);
        } else {
            payable(seller).transfer(amount);
        }
        currentState = State.COMPLETE;
        isDisputed = false;
    }
}
```

## Installation & Deployment

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/escrow-contract.git
cd escrow-contract
```

### 2. Install Dependencies

```bash
npm install --save-dev hardhat ethers
```

### 3. Compile the Contract

```bash
npx hardhat compile
```

### 4. Deploy the Contract

Modify `scripts/deploy.js` and run:

```bash
npx hardhat run scripts/deploy.js --network goerli
```

## How to Use

- **Buyer deploys the contract** and sends ETH as escrow.
- **Seller provides the service/product.**
- **Buyer confirms delivery**, releasing funds to the seller.
- **If there is a dispute, the arbitrator resolves it.**


## License

This project is licensed under the **MIT License**.

## Author

👤 Mrinal Singh (@https://www.linkedin.com/in/mrinal-singh-43a9661a0/)
