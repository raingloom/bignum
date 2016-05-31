local Big = {}
Big.base = 10--for simple testing, use something like 2^16 or 2^8 for practical purposes
Big.__index = Big


local function getBase( a, b )
  local base = a.base
  if b.base == base then
    return base
  else
    return nil, 'Non matching bases'
  end
end


function Big:new( digits, base )
  digits = digits or {}
  digits.base = base
  if not digits.length then
    digits.length = #digits
  end
  return setmetatable( digits, Big )
end


function Big:__tostring()
  local buf, len = {}, self.length
  for i = 1, len do
    buf[i] = self[len-i+1]
  end
  return table.concat( buf )
end


function Big:parse( str )
  assert( self.base==10, 'Only base 10 parsing for now. Sorry.')
  local ret, i = {}, #str
  for c in str:gmatch'.' do
    ret[i], i = tonumber(c), i-1
  end
  return Big:new( ret )
end


function Big:truncateZeros()
  local i = self.length
  while i>0 and self[i]==0 do
    self[i],i=nil,i-1
  end
  self.length=i
  return self
end


function Big:__add( other )
  local base, len, ret = assert( getBase( self, other ) ), math.max( self.length, other.length ), {}
  local rem = false
  for i = 1, len do
    local dig = self[i] or 0
    local x = dig+( other[i] or 0 )
    if rem then x=x+base end
    rem = x>=base
    ret[i] = rem and x%base or x
  end
  if rem then
    ret[len+1]=1
  end
  return Big:new( ret )
end


function Big:__eq( other )
  if self.base ~= other.base or self.length ~= other.length then
    return false
  else
    for i = 1, self.length do
      if self[i] ~= other[i] then
        return false
      end
    end
  end
  return true
end


function Big:__lt( other )
  if self.length == other.length then
    return self.length < other.length
  else
    for i = 1, self.length do
      if self[i] >= other[i] then
        return false
      end
    end
    return true
  end
end


--correct-er way, but slower, due to loop initialization, we could do it in constant time if we could be certain that the number is always truncated, but since manual changes in digits are allowed, we can't be certain
function Big:isZero()
  for i = 1, self.length do
    if self[i] ~= 0 then return false end
  end
  return true
end


function Big:__sub( other )
  local base, len, ret = assert( getBase( self, other ) ), math.max( self.length, other.length ), {}
  local rem = false
  for i = 1, len do
    local sdig, odig = self[i] or 0, other[i] or 0
    rem=rem and 1 or 0
    if sdig < odig then
      ret[i], rem = base-(odig-sdig)-rem, true
    else
      ret[i], rem = sdig-odig-rem, false
    end
  end
  return Big:new( ret ):truncateZeros()
end


function Big:__mul( other )
  local base, ret = assert( getBase( self, other ) ), {}
  local rem = 0
  for i = 1, self.length do
    for j = 1, other.length do
      local x = self[i]*other[j]+(ret[i+j-1] or 0)
      ret[i+j-1] = x%base
      ret[i+j] = math.floor(x/base)
    end
  end
  return Big:new( ret )
end


function Big:__div( other )
  error"TODO"
end


return Big
