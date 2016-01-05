# bignum
A pure Lua bignum library

## `big.lua`
Basic unsigned arithmetic and parsing.

## `num.lua`
**TODO** Signed arithmetic and additional operations and algorithms

# Usage
```
local a = Big:parse"12345"
local b = Big:parse"67890"
print( a*b )
```
