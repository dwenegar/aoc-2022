local INPUT_FILENAME = not arg[1] and 'day02+test.txt' or 'day02.txt'

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
