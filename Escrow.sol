// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbitrator;
    uint public amount;
    bool public isDisputed;

    enum State {
        AWAITING_PAYMENT,
        AWAITING_DELIVERY,
        COMPLETE,
        DISPUTED
    }
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
        require(
            currentState == State.AWAITING_DELIVERY,
            "Not awaiting delivery"
        );
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
