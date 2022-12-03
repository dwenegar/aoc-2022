local M = {}

local next = next
local type = type
local ipairs = ipairs
local pairs = pairs
local print = print
local tostring = tostring

local io_lines = io.lines
local os_clock = os.clock
local tbl_insert = table.insert
local tbl_concat = table.concat

local _ENV = M

local EscapeSequences = {
  ['\a']='\\a',
  ['\b']='\\b',
  ['\f']='\\f',
  ['\n']='\\n',
  ['\r']='\\r',
  ['\t']='\\t',
  ['\v']='\\v',
  ['\\']='\\\\',
  ['\'']='\\\'',
}

local function escape(s)
  return s:gsub('.', EscapeSequences)
end

local function quote(s)
  return ("'%s'"):format(s)
end

local noop = function() end

local DefaultOptions = {
  comma = true,
  indent_size = 2,
  max_depth = 10,
  minimize = false,
  number_format = '%.16g',
  indent_style = 'space',
  smart_keys = true,
  sort_keys = true,
}

local function merge_options(options, defaults)
  if not options then
    return defaults
  end
  local r = {}
  for k, v in pairs(options) do
    r[k] = v
  end
  for k, v in pairs(defaults) do
    if options[k] == nil then
      r[k] = v
    else
      r[k] = options[k]
    end
  end
  return r
end

local function keys(t)
  local k
  return function()
    k = next(t, k)
    return k
  end
end

local Keywords = {
  ['and'] = true, ['break'] = true,  ['do'] = true,
  ['else'] = true, ['elseif'] = true, ['end'] = true,
  ['false'] = true, ['for'] = true, ['function'] = true,
  ['if'] = true, ['in'] = true,  ['local'] = true, ['nil'] = true,
  ['not'] = true, ['or'] = true, ['repeat'] = true,
  ['return'] = true, ['then'] = true, ['true'] = true,
  ['until'] = true,  ['while'] = true
}

local function is_identifier(s)
  return type(s) == 'string' and s:find('^[%a_][%w_]*$') and not Keywords[s]
end

function dump(t, opts)

  opts = merge_options(opts, DefaultOptions)

  local refs, ref_positions = {}, {}
  local function add_ref(x)
    if not refs[x] then
      refs[x] = '<>'
    end
  end

  -- invoked after a reference has been inserted at the specified position.
  local function update_ref_positions(pos)
    for k, ref_pos in pairs(ref_positions) do
      if ref_pos > pos then
        ref_positions[k] = ref_pos + 1
      end
    end
  end

  local comma = opts.comma
  local indent_size = opts.indent_size
  local limit = opts.limit
  local max_depth = opts.max_depth
  local minimize = opts.minimize
  local number_format = opts.number_format
  local smart_keys = opts.smart_keys
  local sort_keys = opts.sort_keys
  local indent_with_tabs = opts.indent_style == 'tab'

  local buf = {}

  local level, indent_cache = 0, {}
  local add_indent = (minimize or indent_size <= 0) and noop or function()
    local indent = indent_cache[level]
    if not indent then
      if level == 1 then
        indent = indent_with_tabs and '\t' or (' '):rep(indent_size)
      else
        indent = indent_cache[1]:rep(level)
      end
      indent_cache[level] = indent
    end
    buf[#buf + 1] = indent
  end

  local add_comma = not comma and noop or function()
    buf[#buf + 1] = ','
  end

  local add_nl = minimize and noop or function()
    buf[#buf + 1] = '\n'
  end

  local add_value -- forward declaration

  local function add_key(x)
    if smart_keys and is_identifier(x) then
      buf[#buf + 1] = x
      buf[#buf + 1] = minimize and '=' or ' = '
    else
      buf[#buf + 1] = '['
      add_value(x)
      buf[#buf + 1] = minimize and ']=' or '] = '
    end
  end

  local function add_table(x)
    if not refs[x] then
      ref_positions[x] = #buf + 1
    end

    if refs[x] then
      buf[#buf + 1] = refs[x]
      return
    end

    if not next(x) then
      buf[#buf + 1] = '{}'
      return
    end

    if level >= max_depth then
      buf[#buf + 1] = '{...}'
      return
    end

    buf[#buf + 1] = '{'
    level = level + 1

    local n = 1
    for k in keys(x, sort_keys) do
      add_nl()
      add_indent()

      if limit and limit < n then
        buf[#buf + 1] = '...'
        break
      end

      add_key(k)
      add_value(x[k])
      add_comma()
      n = n + 1
    end

    if buf[#buf] == ',' then
      buf[#buf] = nil
    end

    add_nl()

    level = level - 1
    add_indent()
    buf[#buf + 1] = '}'
  end

   add_value = function(x)
    if x == nil then
      buf[#buf + 1] = 'nil'
      return
    end

    local tv = type(x)
    if tv == 'string' then
      buf[#buf + 1] = quote(escape(x))
    elseif tv == 'number' then
      buf[#buf + 1] = number_format:format(x)
    elseif tv == 'boolean' then
      buf[#buf + 1] = tostring(x)
    elseif tv == 'table' then
      local pos = ref_positions[x]
      if pos then
        add_ref(x)
        tbl_insert(buf, pos, refs[x])
        ref_positions[x] = nil
        update_ref_positions(pos)
      end
      add_table(x)
    else
      buf[#buf + 1] = '<'
      buf[#buf + 1] = tostring(x)
      buf[#buf + 1] = '>'
    end
  end

  add_value(t)
  print(tbl_concat(buf))
end

function to_set(a)
  local s = {}
  for _, x in ipairs(a) do
    s[x] = true
  end
  return s
end

function sum(a, n)
  n = n or #a
  local sum = 0
  for i = 1, n do
    sum = sum + a[i]
  end
  return sum
end

function avg(a)
  return sum(a) / #a
end

function max(a, f)
  f = f or function(x) return x end
  local r = f(a[1])
  for i = 2, #a do
    if f(a[i]) > r then
      r = f(a[i])
    end
  end
  return r
end

function lines(filename, f)
  f = f or function(x) return x end
  local iter = io_lines(filename)
  return function()
    return f(iter())
  end
end

function time(f, ...)
  local start = os_clock()
  local r = f(...)
  return 'result', r, 'time', os_clock() - start
end

local function unique(s, f)
  f = f or function(x) return x end
  local r = {}
  for x in s:gmatch('.') do
    r[f(x)] = true
  end
  return r
end

local function unique(s, f)
  f = f or function(x) return x end
  local r = {}
  for x in s:gmatch('.') do
    r[f(x)] = true
  end
  return r
end

return M
