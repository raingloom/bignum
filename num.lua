local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''
local Big = require( prefix..'big' )
local Num = setmetatable( {}, {__index = Big} )
Num.__index = Num


function Num:new( sign, digits )
  local ret = setmetatable( Big:new( digits ), Num )
  ret.sign = sign==nil and true or false
  return ret
end


---[[
function Num:parse( ... )
  return Num:new( Big:parse( ... ) )
end
--]]


--there is no way we are gonna cache an arbitrary number of arbitrary length numbers' factorials, especially since that would require hashing them, as tables are, as everyone knows, not compared element-wise
function Num:factorial( _limit )
  if _limit and self==limit or self:isZero() then
    return Num:new{ 0 }
  else
    return self * Num.factorial( self-Num:new{ 1 }, _limit )
  end
end


return Num