***Practice 1 — the "mirror the same calculation" pattern (same skill as CoinFlip)***

```solidity
contract GuessTheNumber {
    uint8 public constant answer = 42;

    function guess(uint8 _guess) public payable returns (bool) {
        require(msg.value == 1 ether);
        if (_guess == answer) {
            (bool sent, ) = msg.sender.call{value: 2 ether}("");
            require(sent);
            return true;
        }
        return false;
    }
}
```

***Practice 2 — calling a function with the right value, not just the right argument (payable mechanics)***

```solidity
contract PiggyBank {
    address public owner;
    constructor() { owner = msg.sender; }

    function deposit() public payable {}

    function withdraw() public {
        require(msg.sender == owner, "not owner");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
```

***(This one's a trick — read it very carefully. Is it actually exploitable, or is this one a control to test whether you correctly conclude "no bug here"?)***

***Practice 3 — attacking via the constructor, not a named function (mirrors your CoinFlip constructor-based approach)***

```solidity
contract OneTimeClaim {
    mapping(address => bool) public claimed;
    uint256 public constant PRIZE = 0.5 ether;

    function claim() public {
        require(!claimed[tx.origin], "already claimed");
        claimed[tx.origin] = true;
        payable(tx.origin).transfer(PRIZE);
    }

    receive() external payable {}
}
```

***Practice 4 — multi-step attack contract with two calls, not one (chaining logic)***

```solidity
contract VotingBooth {
    mapping(address => bool) public hasVoted;
    uint256 public yesVotes;
    uint256 public noVotes;

    function vote(bool _yes) public {
        require(!hasVoted[msg.sender], "already voted");
        hasVoted[msg.sender] = true;
        if (_yes) yesVotes++;
        else noVotes++;
    }
}
```