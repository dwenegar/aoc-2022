local utils = require 'utils'

local INPUT_FILENAME = not arg[1] and 'day01+test.txt' or 'day01.txt'

local function read_input()
  local elves, elf = {}, 0
  for line in io.lines(INPUT_FILENAME) do
    if not tonumber(line) then
      table.insert(elves, elf)
      elf = 0
    else
      elf = elf + tonumber(line)
    end
  end
  table.insert(elves, elf)
  return elves
end

local function calculate_result_1()
  local elves = read_input()
  return utils.max(elves)
end

local function calculate_result_2()
  local elves = read_input()
  table.sort(elves, function(x, y) return x > y end)
  return utils.sum(elves, 3)
end

local function time(f)
  local start = os.clock()
  local r = f()
  return 'result', r, 'time', os.clock() - start
end

print('PART 1', time(calculate_result_1))
print('PART 2', time(calculate_result_2))
