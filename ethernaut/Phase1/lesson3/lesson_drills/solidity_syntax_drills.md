# Solidity Syntax Drills — 5 Core Patterns

These are the only 5 patterns you need for CoinFlip (and most early Ethernaut levels). Memorize the *shape*, not the specific values.

---

## Pattern 1 — State variable declaration
```solidity
<type> <visibility?> <name> = <value>;
```
Examples:
```solidity
uint256 public count = 0;
address target;
bool active = true;
```
Visibility (`public`, `private`, `internal`) is optional — if omitted, defaults to `internal`.

---

## Pattern 2 — Constructor
```solidity
constructor(<params>) {
    <body>
}
```
Examples:
```solidity
constructor() {
    count = 0;
}

constructor(address _target) {
    target = _target;
}
```
Runs exactly once, at deployment. Takes real parameters if you need setup data (like a target address).

---

## Pattern 3 — Function definition
```solidity
function <name>(<params>) <visibility> <modifiers?> returns (<type>) {
    <body>
}
```
Examples:
```solidity
function hack() public {
    // no return
}

function getSide() public view returns (bool) {
    return true;
}

function flip(bool _guess) public returns (bool) {
    return _guess;
}
```

---

## Pattern 4 — Calling another deployed contract (typed)
```solidity
<ContractName> <varName> = <ContractName>(<address>);
<varName>.<functionName>(<args>);
```
Example:
```solidity
CoinFlip public target;

constructor(address _targetAddress) {
    target = CoinFlip(_targetAddress);
}

function hack() public {
    target.flip(true);
}
```
Requires the full `CoinFlip` contract source to be visible in the same file (or imported).

---

## Pattern 5 — Calling another contract (low-level, no source needed)
```solidity
(bool success, ) = <address>.call(
    abi.encodeWithSignature("<functionName>(<paramTypes>)", <args>)
);
require(success);
```
Example:
```solidity
(bool success, ) = target.call(
    abi.encodeWithSignature("flip(bool)", side)
);
require(success);
```
`target` here is just a plain `address`, not a typed contract variable.

---

# 50 Practice Problems

Fill in the blank / write the missing line. Don't overthink — pattern-match to the 5 shapes above. Answers are at the bottom — **don't peek until you've written all 50.**

### Section A — Variable declarations (1–10)
1. Declare a public `uint256` called `total` starting at `0`.
2. Declare a private `address` called `owner` with no initial value.
3. Declare a `bool` called `isLocked` set to `false`.
4. Declare a public `uint256` called `FACTOR` set to `100`.
5. Declare an `address` called `target` with no initial value.
6. Declare a public `bool` called `hasClaimed` set to `false`.
7. Declare a `uint256` called `price` set to `1000000000000000000`.
8. Declare a public `address` called `winner`.
9. Declare a `uint8` called `maxGuess` set to `9`.
10. Declare a public `uint256` called `deadline`.

### Section B — Constructors (11–20)
11. Write a constructor that takes no parameters and sets `count = 0`.
12. Write a constructor that takes `address _owner` and sets `owner = _owner`.
13. Write a constructor that takes `uint256 _price` and sets `price = _price`.
14. Write a constructor that takes `address _target` and assigns it to a state variable `target`.
15. Write a constructor that takes two params, `address _a` and `uint256 _b`, and sets both.
16. Write a constructor that sets `active = true` (no params).
17. Write a constructor that takes `address _targetAddress` and sets `target = TargetContract(_targetAddress)` (typed pattern).
18. Write a constructor that takes `uint256 _factor` and sets `FACTOR = _factor`.
19. Write a constructor that sets `owner = msg.sender` (no params — this is a very common real pattern, look up what `msg.sender` means if unfamiliar).
20. Write a constructor that takes `bool _start` and sets `active = _start`.

### Section C — Function definitions (21–30)
21. Write a public function `reset()` that sets `count = 0`. No return value.
22. Write a public `view` function `getCount()` that returns `count` (a `uint256`).
23. Write a public function `setOwner(address _new)` that sets `owner = _new`.
24. Write a public function `hack()` with no parameters and no return value — empty body for now.
25. Write a public function `guess(uint8 _num)` that returns a `bool`.
26. Write a public `view` function `isActive()` that returns `active` (a `bool`).
27. Write a public function `deposit()` that is `payable` (no body needed, just the signature).
28. Write a public function `attack(address _target)` with no return value — empty body.
29. Write a public `view` function `computeSide()` that returns a `bool` — empty body for now (just the signature + `returns`).
30. Write a public function `flip(bool _guess)` that returns a `bool` — empty body for now.

### Section D — Typed contract calls (31–40)
31. Given a contract `Bank`, declare a public state variable `target` of type `Bank`.
32. Inside a constructor taking `address _addr`, assign `target = Bank(_addr)`.
33. Call a function `withdraw()` on `target` (no args, no return used).
34. Call a function `deposit(uint256 _amount)` on `target`, passing `100`.
35. Given `target` is type `CoinFlip`, call its `flip` function passing a local variable `side`.
36. Declare `CoinFlip public target;` and a constructor that sets it from `address _targetAddress`.
37. Call `target.guess(_guess)` where `_guess` is a function parameter of type `uint8`.
38. Store the result of `target.isActive()` into a local variable `bool result`.
39. Given a contract `Vault`, write the full pattern: declare `target`, constructor, and one call to `target.claim()`.
40. Call `target.setOwner(msg.sender)`.

### Section E — Low-level calls (41–50)
41. Write a low-level call to `target` for a function `reset()` with no arguments.
42. Write a low-level call to `target` for a function `flip(bool)`, passing local variable `side`.
43. Write a low-level call to `target` for a function `deposit(uint256)`, passing `500`.
44. Write a low-level call to `target` for a function `setOwner(address)`, passing `msg.sender`.
45. Write a low-level call to `target` for a function `guess(uint8)`, passing local variable `myGuess`.
46. Add the `require(success)` line after a low-level call stored in `(bool success, )`.
47. Write a low-level call to `target` for a function `claim()` with no arguments, and require it succeeds.
48. Write a low-level call to `target` for a function `vote(bool)`, passing `true` directly (not a variable).
49. Write a low-level call to `target` for a function `attack(address,uint256)`, passing `msg.sender` and `42`.
50. Combine it: declare `address public target;`, a constructor setting it, and a function `hack()` that low-level calls `flip(bool)` on it, passing `true`.

---

# Answers

<details>
<summary>Click to expand — only after attempting all 50</summary>

1. `uint256 public total = 0;`
2. `address private owner;`
3. `bool isLocked = false;`
4. `uint256 public FACTOR = 100;`
5. `address target;`
6. `bool public hasClaimed = false;`
7. `uint256 price = 1000000000000000000;`
8. `address public winner;`
9. `uint8 maxGuess = 9;`
10. `uint256 public deadline;`

11. `constructor() { count = 0; }`
12. `constructor(address _owner) { owner = _owner; }`
13. `constructor(uint256 _price) { price = _price; }`
14. `constructor(address _target) { target = _target; }`
15. `constructor(address _a, uint256 _b) { a = _a; b = _b; }`
16. `constructor() { active = true; }`
17. `constructor(address _targetAddress) { target = TargetContract(_targetAddress); }`
18. `constructor(uint256 _factor) { FACTOR = _factor; }`
19. `constructor() { owner = msg.sender; }`
20. `constructor(bool _start) { active = _start; }`

21. `function reset() public { count = 0; }`
22. `function getCount() public view returns (uint256) { return count; }`
23. `function setOwner(address _new) public { owner = _new; }`
24. `function hack() public { }`
25. `function guess(uint8 _num) public returns (bool) { }`
26. `function isActive() public view returns (bool) { return active; }`
27. `function deposit() public payable { }`
28. `function attack(address _target) public { }`
29. `function computeSide() public view returns (bool) { }`
30. `function flip(bool _guess) public returns (bool) { }`

31. `Bank public target;`
32. `target = Bank(_addr);`
33. `target.withdraw();`
34. `target.deposit(100);`
35. `target.flip(side);`
36. `CoinFlip public target; constructor(address _targetAddress) { target = CoinFlip(_targetAddress); }`
37. `target.guess(_guess);`
38. `bool result = target.isActive();`
39. `Vault public target; constructor(address _addr) { target = Vault(_addr); } function hack() public { target.claim(); }`
40. `target.setOwner(msg.sender);`

41. `(bool success, ) = target.call(abi.encodeWithSignature("reset()")); `
42. `(bool success, ) = target.call(abi.encodeWithSignature("flip(bool)", side));`
43. `(bool success, ) = target.call(abi.encodeWithSignature("deposit(uint256)", 500));`
44. `(bool success, ) = target.call(abi.encodeWithSignature("setOwner(address)", msg.sender));`
45. `(bool success, ) = target.call(abi.encodeWithSignature("guess(uint8)", myGuess));`
46. `require(success);`
47. `(bool success, ) = target.call(abi.encodeWithSignature("claim()")); require(success);`
48. `(bool success, ) = target.call(abi.encodeWithSignature("vote(bool)", true));`
49. `(bool success, ) = target.call(abi.encodeWithSignature("attack(address,uint256)", msg.sender, 42));`
50.
```solidity
address public target;

constructor(address _target) {
    target = _target;
}

function hack() public {
    (bool success, ) = target.call(
        abi.encodeWithSignature("flip(bool)", true)
    );
    require(success);
}
```

</details>