// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/* is Ownable(tx.origin) */
contract Quiz {
    bytes32 internal constant QUESTION = "Can you guess the secret string?";
    address public immutable owner;
    bytes32 public answer;
    address public winner;

    modifier onlyOwner() {
        _onlyOwner();
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Make sure only the owner can call initialize and do it once
    function initialize(bytes32 _answer) external payable onlyOwner {
        if (
            answer !=
            0x0000000000000000000000000000000000000000000000000000000000000000
        ) {
            revert();
        }
        answer = _answer;
    }

    function _onlyOwner() internal view returns (bool) {
        return msg.sender == owner;
    }

    function getHash(string memory str) external pure returns (bytes32) {
        return keccak256(abi.encode(str));
    }

    function getQuestion() external pure returns (string memory) {
        return string(abi.encode(QUESTION));
    }

    function getPrizePool() external view returns (uint) {
        return address(this).balance;
    }

    function guess(string memory _guess) external returns (bool) {
        bytes32 hash = keccak256(abi.encode(_guess));
        if (hash == answer) {
            winner = msg.sender;
            payable(winner).transfer(address(this).balance);
            return true;
        }
        return false;
    }

    receive() external payable {}
}
