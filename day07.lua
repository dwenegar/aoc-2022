local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and 'day07+test.txt' or 'day07.txt'

local function read_input()
  local root, it
  for line in io.lines(INPUT_FILENAME) do
    local cd_arg = line:match('^%$ cd (%S+)$')
    if cd_arg == '..' then
      local p = it.parent
      p.size = p.size + it.size
      it = p
    elseif cd_arg then
      local c = { name = cd_arg, parent = it, size = 0 }
      if not root then
        root = c
      else
        table.insert(it, c)
      end
      it = c
    else
      local size = line:match('^(%d+) ')
      if size then
        it.size = it.size + tonumber(size)
      end
    end
  end
  while it.parent do
    local p = it.parent
    p.size = p.size + it.size
    it = p
  end
  return root
end

local function visit(d, f)
  f(d)
  for _, x in ipairs(d) do
    visit(x, f)
  end
end

local function calculate_result_1()
  local r = 0
  visit(read_input(), function(x)
    if x.size <= 100000 then
      r = r + x.size
    end
  end)
  return r
end

local function calculate_result_2()
  local root = read_input()
  local r = 70000000
  visit(root, function(x)
    if root.size - x.size <= 40000000 and x.size < r then
      r = x.size
    end
  end)
  return r
end

print('PART 1', utils.time(calculate_result_1))
print('PART 2', utils.time(calculate_result_2))
