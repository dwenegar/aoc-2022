local utils = require 'utils'
local iter = require 'iter'
local stringx = require 'stringx'

local INPUT_FILENAME = not arg[1] and 'day03+test.txt' or 'day03.txt'

local function to_priority(item)
  item = item:byte()
  return (item >= 97 and (item - 96) or (item - 38))
end

local function calculate_result_1()
  local function find_item_in_both_compartments(items)
    local seen = {}
    for i, c in stringx.ichars(items) do
      if i <= #items // 2 then
        seen[c] = true
      elseif seen[c] then
        return c
      end
    end
  end

  local r = 0
  for items in io.lines(INPUT_FILENAME) do
    local item = find_item_in_both_compartments(items)
    r = r + to_priority(item)
  end
  return r
end

local function calculate_result_2()
  local function find_badge_item(group)
    local t = {}
    for i, items in ipairs(group) do
      for item in stringx.distinct(items) do
        t[item] = (t[item] or 0) + 1
        if i == 3 and t[item] == 3 then
          return item
        end
      end
    end
  end

  local r = 0
  for group in iter.group(io.lines(INPUT_FILENAME), 3) do
    local item = find_badge_item(group)
    r = r + to_priority(item)
  end
  return r
end

print('PART 1', utils.time(calculate_result_1))
print('PART 2', utils.time(calculate_result_2))
