local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and 'day05+test.txt' or 'day05.txt'

local function moves(lines)
  return function()
    local line = lines()
    if not line then return end
    local n, s, e = line:match('^move (%d+) from (%d+) to (%d+)')
    return tonumber(n), tonumber(s), tonumber(e)
  end
end

local function parse_stacks(input)
  local lines = {}
  for line in input do
    if #line == 0 then break end
    table.insert(lines, line)
  end

  local stacks = {}
  for i = #lines - 1, 1, -1 do
    local s, e, crate
    while true do
      s, e, crate = lines[i]:find('%[(.)%]', (e or 0) + 1)
      if not s then break end
      local j = 1 + (s - 1) // 4
      stacks[j] = stacks[j] or {}
      table.insert(stacks[j], crate)
    end
  end
  return stacks
end

local function calculate_result(move)
  local lines = io.lines(INPUT_FILENAME)
  local stacks = parse_stacks(lines)
  for n, s, e in moves(lines) do
    move(stacks, n, s, e)
  end
  local t = {}
  for _, stack in ipairs(stacks) do
    table.insert(t, stack[#stack])
  end
  return table.concat(t)
end

local function calculate_result_1()
  return calculate_result(function(stacks, n, s, e)
    local i = #stacks[e]
    for j = 1, n do
      stacks[e][i + j] = table.remove(stacks[s], #stacks[s])
    end
  end)
end

local function calculate_result_2()
  return calculate_result(function(stacks, n, s, e)
    local i = #stacks[e]
    for j = n, 1, -1 do
      stacks[e][i + j] = table.remove(stacks[s], #stacks[s])
    end
  end)
end

print('PART 1', utils.time(calculate_result_1))
print('PART 2', utils.time(calculate_result_2))
