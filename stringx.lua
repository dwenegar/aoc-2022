local M = {}

local _ENV = M

local function identity(x)
  return x
end

function chars(s)
  local i = 0
  return function()
    i = i + 1
    return s:sub(i, i)
  end
end

function ichars(s)
  local i = 0
  return function()
    i = i + 1
    if i > #s then return end
    return i, s:sub(i, i)
  end
end

function distinct(s, f)
  f = f or identity
  local i, seen = 0, {}
  return function()
    while i < #s do
      i = i + 1
      local c = s:sub(i, i)
      if not seen[c] then
        seen[c] = true
        return f(c)
      end
    end
  end
end

return M
