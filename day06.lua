local iox = require 'iox'
local stringx = require 'stringx'
local array = require 'array'
local utils = require 'utils'

local INPUT_FILENAME = not arg[1] and 'day06+test.txt' or 'day06.txt'

local function get_input()
  return stringx.chars(iox.read_all(INPUT_FILENAME))
end

local function calculate_result(len)
  return array.each_cons(get_input(), len, function(a, i)
    local _, n = array.to_set(a)
    if n == len then
      return i + len - 1
    end
  end)
end

print('PART 1', utils.time(calculate_result, 4))
print('PART 2', utils.time(calculate_result, 14))
