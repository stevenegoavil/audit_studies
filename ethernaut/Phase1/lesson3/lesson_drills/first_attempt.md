## Section A
1. ``` uint245 total=0;``` x wrong - correct ``` uint256 public total = 0;```
2. ``` address private owner;```
3. ``` bool isLocked = false;```
4. ``` uint256 FACTOR = 100;``` x wrong - correct ``` uint256 public FACTOR = 100;```
5. ``` address target;```
6. ``` bool hasClaimed = false;``` x wrong - correct ``` bool public hasClaimed = false;```
7. ``` uint256 price = 1000000000000000000;```
8. ``` address winner;``` x wrong - correct ``` address public winner;```
9. ``` uint8 maxGuess = 9;```
10. ``` uint256 deadline;``` x wrong - correct ``` uint256 public deadline;```

## Section B
11. ``` constructor() { count = 0;}```
12. ``` constructor(address _owner) {owner = _owner;}```
13. ```constructor(uint256 _price) {price = _price; } ```
14. ```constructor(address _target) {target;} ``` x wrong - correction ``` constructor(address _target) { target = _target;}```
15. ``` constructor(address _a, uint256 _b){ }``` x wrong - correct ```constructor(address _a, uint256 _b){a=_a; b=_b;} ```
16. ```constructor(){active = true;}```
17. ```constructor(address _targetAddress){target = TargetContract(_targetAddress);}```
18. ```constructor(uint256 _factor){FACTOR = _factor;}```
19. ```constructor(){owner = msg.sender;} ```
20. ```constructor(bool _start) { active = _start;} ```

## Section C
21. ```function reset() public {count = 0; return } ```
22. ```function getCount() public view (uint256){ return count}```
23. ```function setOwner(address _new) public { owner = _new;} ```
24. ```function hack() public {} ```
25. ``` function guess(uint8 _num) public returns (bool){} ```
26. ```function isActive() public view returns (bool){ return active} ```
27. ```function deposit() public payable {} ```
28. ```function attack(address _target) public{} ```
29. ```function computeSide() public view returns(bool){} ``` 
30. ```function flip(bool _guess) public returns(bool) {} ```
## Section D (first attempt)
31. ```target public Bank; ```
32. ```constructor(address _addr){ target = Bank(_addr);} ``` 
33. ```target.withdraw() ```
34. ```target.deposit(100) ```
35. ```target.flip() ```
36. ```target = CoinFlip(_targetAddress); ```
37. ```target.guess(uint8 _guess) ```
38. ```target.isActive(bool result) ```
39. ```target ```
40. ``` ```

## Section D (second attempt)
31. ```pool public LendingPool; ```
35. ```target.draw(ticketId) ```
36. ```Vault public safe; 
        constructor(address _vaultAddress){
            safe = Vault(_vaultAddress);
        }```
37. ```uint256.borrow(_amount)```
38. ```uint256 bal = pool.getBalance() ```
39. ```Escrow public target;
    constructor(address _addr){
        target = Escrow(_addr);
    }
    function release() public{
        target.releaseFunds();
}```
40. ```target.setAdmin(msg.sender);```