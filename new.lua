local day = tonumber(arg[1])
local base = ('day%02d'):format(day)

local function touch(filename, content)
  local f = io.open(filename, 'w+')
  if content then
    f:write(content)
  end
  f:close()
end

local content = [[
local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and '%s+test.txt' or '%s.txt'

local function calculate_result_1()
end

local function calculate_result_2()
end

print('PART 1', utils.time(calculate_result_1))
print('PART 2', utils.time(calculate_result_2))
]]

touch(base .. '.lua', content:format(base, base))
touch(base .. '.txt')
touch(base .. '+test.txt')
