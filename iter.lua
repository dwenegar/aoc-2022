local M = {}

local P = print
local tbl_insert = table.insert

local _ENV = M

local function identity(x)
  return x
end

function group(iter, n)
  local t1, t2 = {}, nil
  return function()
    while true do
      local x = iter()
      if not x then return nil end
      t1 = t1 or {}
      tbl_insert(t1, x)
      if #t1 == n then
        t2, t1 = t1, nil
        return t2
      end
    end
  end
end

function sum(iter, f)
  f = f or identity
  local r = 0
  for x in iter do
    r = r + f(x)
  end
  return r
end

function map(iter, f)
  return function()
    local x = iter()
    if not x then return end
    return f(x)
  end
end

return M
