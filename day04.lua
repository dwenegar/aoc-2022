local iter = require 'iter'
local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and 'day04+test.txt' or 'day04.txt'

local function ranges()
  local lines = io.lines(INPUT_FILENAME)
  return iter.map(lines, function(line)
    local s1, e1, s2, e2 = line:match('^(%d+)%-(%d+),(%d+)%-(%d+)$')
    return { s = tonumber(s1), e = tonumber(e1) }, { s = tonumber(s2), e = tonumber(e2) }
  end)
end

local function calculate_result_1()
  local r = 0
  for r1, r2 in ranges() do
    if (r1.s <= r2.s and r1.e >= r2.e) or (r2.s <= r1.s and r2.e >= r1.e) then
      r = r + 1
    end
  end
  return r
end

local function calculate_result_2()
  local r = 0
  for r1, r2 in ranges() do
    if not (r2.e < r1.s or r1.e < r2.s) then
      r = r + 1
    end
  end
  return r
end

print('PART 1', utils.time(calculate_result_1))
print('PART 2', utils.time(calculate_result_2))
