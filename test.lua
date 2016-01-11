--[[local N = require'num'

local a, b = N:parse'3', N:parse'322'

print( a:factorial().__tostring )
]]


local c1 = {}
function c1:__tostring()
  return "sdfgh --Temmie, the Wise"
end
local c2 = setmetatable({},{__index=function(_,k)return c1[k]end})
c2.__index = c2
print( setmetatable({},c2) )