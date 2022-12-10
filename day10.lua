local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and 'day10+test.txt' or 'day10.txt'

local function parse_inst(line)
  local v = line:match('^addx (%-?%d+)$')
  if v then
    return 2, function(x)
      return x + tonumber(v)
    end
  end
  return 1
end

local function calculate_result_1()
  local c, x, r = 0, 1, 0
  for line in io.lines(INPUT_FILENAME) do
    local cycles, f = parse_inst(line)
    for _ = 1, cycles do
      c = c + 1
      if c == 20 or (c - 20) % 40 == 0 then
        r = r + c * x
      end
    end
    if f then
      x = f(x)
    end
  end
  return r
end

local function calculate_result_2()
  local c, x = 0, 1
  local pixels = {}
  for line in io.lines(INPUT_FILENAME) do
    local cycles, f = parse_inst(line)
    for _ = 1, cycles do
      local i = c % 40
      pixels[c + 1] = (x - 1 <= i and i <= x + 1) and '#' or '.'
      c = c + 1
    end
    if f then
      x = f(x)
    end
  end
  local r = {}
  for i = 1, 6 do
    local t = {}
    for j = 1, 40 do
      t[j] = pixels[j + (i - 1) * 40]
    end
    r[i] = table.concat(t)
  end
  return '\n' .. table.concat(r, '\n')
end

print('PART 1', utils.time(calculate_result_1))
print('PART 2', utils.time(calculate_result_2))
