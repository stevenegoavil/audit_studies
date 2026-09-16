## Write one from scratch

# September 16 2026 - Charity Contract

A contract called Charity contract that sets owner and a goalAmount passed in as a
parameter. Try it blind first.

## Attempt Log

**charity.sol** — 1st attempt
- Missing space in pragma (`solidity^0.9.0` → needs space + `^0.8.0`)
- Typo: `contructor` instead of `constructor` — accidentally recreated the exact
  Level 2 Fallout vulnerability (misspelled constructor becomes a public function)
- Referenced `_goalAmount` without declaring it as a constructor parameter

**charity2.sol** — 2nd attempt
- Fixed constructor spelling
- New bug: `constructor(uint256, _goalAmount)` — comma incorrectly separating type
  from parameter name (should be `uint256 _goalAmount`, space not comma)
- Removed the `goalAmount` state variable declaration by mistake

**charity3.sol** — 3rd attempt — clean
- All syntax correct
- Real understanding check: why does the constructor use `_goalAmount` (param)
  separately from `goalAmount` (state variable) instead of one name?

## Key Concept Learned

`_goalAmount` = local parameter, only exists while the constructor is running,
never touches the blockchain.

`goalAmount` = state variable, lives permanently in contract storage, forever
visible to every function.

The underscore convention isn't a compiler requirement — it's a human-readability
safeguard. Using the same name for both would compile fine but creates ambiguous
lines like `goalAmount = goalAmount` that are easy to misread or introduce silent
bugs into, especially in someone else's contract.

## Takeaway

The comma-vs-space distinction in constructor attempt 2 is the same category of
error as level 2's Fallout bug — a single character of syntax silently changes
what the code actually does. Precision at this level is the actual job.