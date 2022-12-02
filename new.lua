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
local INPUT_FILENAME = not arg[1] and '%s+test.txt' or '%s.txt'

local function calculate_result_1()
end

local function calculate_result_2()
end

local function time(f)
  local start = os.clock()
  local r = f()
  return 'result', r, 'time', os.clock() - start
end

print('PART 1', time(calculate_result_1))
print('PART 2', time(calculate_result_2))
]]

touch(base .. '.lua', content:format(base, base))
touch(base .. '.txt')
touch(base .. '+test.txt')
