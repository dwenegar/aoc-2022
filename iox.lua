---
-- @module std.iox

local M = {}

local io_open = io.open

local _ENV = M

function read_lines(filename)
  local fh, err = io_open(filename, 'r')
  if not fh then
    return nil, err
  end

  local t = {}
  while true do
    local line
    line, err = fh:read('l')
    if err or not line then
      break
    end
    t[#t + 1] = line
  end
  fh:close()
  return t, err
end

function write_lines(filename, lines)
  local fh, err = io_open(filename, 'w')
  if not fh then
    return false, err
  end

  local _
  for i = 1, #lines do
    _, err = fh:write(lines[i], '\n')
    if err then
      break
    end
  end
  fh:close()
  return not err, err
end

local function read_file(filename, what)
  local fh, err = io_open(filename, 'r')
  if not fh then
    return nil, err
  end

  local r
  r, err = fh:read(what)
  fh:close()
  return r, err
end

function read_n(filename, n)
  return read_file(filename, n)
end

function read_all(filename)
  return read_file(filename, 'a')
end

function write_all(filename, content)
  local fh, err = io_open(filename, 'w')
  if not fh then
    return false, err
  end

  local _
  _, err = fh:write(content)
  fh:close()
  return err
end

return M

