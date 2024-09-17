// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract Ludo {

    uint8 public totalGamePath;

    event PlayerWon(address);

    constructor() {
        totalGamePath = 57;
    }


    struct Player {
        uint8 position; 
        bool hasStarted;
        bool hasLeftHomeArea;
    }

    mapping(address => Player) players;

    function rollDice() public view returns (uint8) {
        uint8 diceRoll = uint8((uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 6) + 1);
        return diceRoll;
    }

    function getPlayerPosition() external view returns (uint16) {
        return players[msg.sender].position;
    }

    function start() external {
        players[msg.sender] = Player(0, true, false);
    }

    function move() external {
        require(players[msg.sender].hasStarted, "Player has not started yet");

        uint8 diceRoll = rollDice();

        if (!players[msg.sender].hasLeftHomeArea) {
            require(diceRoll == 6, "You need six for the first move");
            players[msg.sender].hasLeftHomeArea = true;
        }

        players[msg.sender].position += diceRoll;

        if (players[msg.sender].position >= 57) {
            players[msg.sender].position = 57;
            emit PlayerWon(msg.sender);
        }
    }

}
