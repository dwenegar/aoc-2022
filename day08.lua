local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and 'day08+test.txt' or 'day08.txt'

local function read_input()
  local r, h, w = {}, 0, nil
  for line in io.lines(INPUT_FILENAME) do
    h = h + 1
    if w then
      assert(w == #line)
    else
      w = #line
    end
    for c in line:gmatch('.') do
      table.insert(r, tonumber(c))
    end
  end

  return r, w, h
end

local function calculate_result_1()
  local trees, w, h = read_input()
  local visible = {}

  -- top -> bottom
  for x = 1, w do
    local max = -1
    for y = 1, h do
      local i = x + (y - 1) * w
      if trees[i] > max then
        max = trees[i]
        visible[i] = true
      end
    end
  end

  -- bottom -> top
  for x = 1, w do
    local max = -1
    for y = h, 1, -1 do
      local i = x + (y - 1) * w
      if trees[i] > max then
        max = trees[i]
        visible[i] = true
      end
    end
  end

  -- left -> right
  for y = 1, h do
    local max = -1
    for x = 1, w do
      local i = x + (y - 1) * w
      if trees[i] > max then
        max = trees[i]
        visible[i] = true
      end
    end
  end

  -- right -> left
  for y = 1, h do
    local max = -1
    for x = w, 1, -1 do
      local i = x + (y - 1) * w
      if trees[i] > max then
        max = trees[i]
        visible[i] = true
      end
    end
  end

  local r = 0
  for _ in pairs(visible) do
    r = r + 1
  end
  return r
end

local function calculate_result_2()
  local trees, w, h = read_input()
  local function get_scenic_score(x0, y0)
    local h0 = trees[x0 + (y0 - 1) * w ]
    -- up
    local up = 0
    for y = y0 - 1, 1, -1 do
      local i = x0 + (y - 1) * w
      up = up + 1
      if trees[i] >= h0 then break end
    end
    -- down
    local down = 0
    for y = y0 + 1, h do
      local i = x0 + (y - 1) * w
      down = down + 1
      if trees[i] >= h0 then break end
    end
    -- left
    local left = 0
    for x = x0 - 1, 1, -1 do
      local i = x + (y0 - 1) * w
      left = left + 1
      if trees[i] >= h0 then break end
    end
    -- right
    local right = 0
    for x = x0 + 1, w do
      local i = x + (y0 - 1) * w
      right = right + 1
      if trees[i] >= h0 then break end
    end
    return up * down * left * right
  end

  local r = -1
  for x = 1, w do
    for y = 1, h do
      r = math.max(r, get_scenic_score(x, y))
    end
  end
  return r
end

print('PART 1', utils.time(calculate_result_1))
print('PART 2', utils.time(calculate_result_2))
