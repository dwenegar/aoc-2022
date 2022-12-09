local utils = require 'utils'
local INPUT_FILENAME = not arg[1] and 'day09+test.txt' or 'day09.txt'

local function do_head_step(dir, node)
  if dir == 'U' then
    node.y = node.y + 1
  elseif dir == 'D' then
    node.y = node.y - 1
  elseif dir == 'R' then
    node.x = node.x + 1
  else
    node.x = node.x - 1
  end
end

local function do_node_step(node, prev)
  local dx, dy = prev.x - node.x, prev.y - node.y
  -- horizontal
  if dy == 0 then
    if dx > 1 then
      node.x = node.x + 1
    elseif dx < -1 then
      node.x = node.x - 1
    end
  elseif dx == 0 then -- vertical
    if dy > 1 then
      node.y = node.y + 1
    elseif dy < -1 then
      node.y = node.y - 1
    end
  else -- diagonal
    if dx > 1 then
      node.x = node.x + 1
      node.y = dy > 0 and node.y + 1 or node.y - 1
    elseif dx < -1 then
      node.x = node.x - 1
      node.y = dy > 0 and node.y + 1 or node.y - 1
    elseif dy > 1 then
      node.y = node.y + 1
      node.x = dx > 0 and node.x + 1 or node.x - 1
    elseif dy < -1 then
      node.y = node.y - 1
      node.x = dx > 0 and node.x + 1 or node.x - 1
    end
  end
end

local function calculate_result(n)
  local nodes = {}
  for i = 1, n do
    nodes[i] = {x = 0, y = 0}
  end
  local visited = {}
  local function simulate(dir, steps)
    local head, tail = nodes[1], nodes[#nodes]
    for _ = 1, steps do
      do_head_step(dir, head)
      for i = 2, #nodes do
        do_node_step(nodes[i], nodes[i - 1])
      end
      visited[tail.x + tail.y * 1000000] = true
    end
  end

  for line in io.lines(INPUT_FILENAME) do
    local dir, steps = line:match('^([UDLR]) (%d+)$')
    simulate(dir, tonumber(steps))
  end
  local r = 0
  for _ in pairs(visited) do
    r = r + 1
  end
  return r
end

print('PART 1', utils.time(calculate_result, 2))
print('PART 2', utils.time(calculate_result, 10))
