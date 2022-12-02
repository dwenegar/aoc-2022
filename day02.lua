local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and 'day02+test.txt' or 'day02.txt'

local function calculate_result(outcomes)
  local r = 0
  for line in io.lines(INPUT_FILENAME) do
    local x, y = line:match('^(%w) (%w)$')
    r = r + outcomes[y][x]
  end
  return r
end

-- A: rock B: paper C: scissor
-- X: rock Y: paper Z: scissor
print('PART 1', utils.time(calculate_result,  {
  X = {A = 4, B = 1, C = 7},
  Y = {A = 8, B = 5, C = 2},
  Z = {A = 3, B = 9, C = 6}
}))

-- A: rock B: paper C: scissor
-- X: lose Y: draw Z: win
print('PART 2', utils.time(calculate_result, {
  X = {A = 3, B = 1, C = 2},
  Y = {A = 4, B = 5, C = 6},
  Z = {A = 8, B = 9, C = 7}
}))
