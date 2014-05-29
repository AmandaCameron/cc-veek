local format = {}

function format.is_a(s)
  if s:sub(-1) ~= "\r" and s:sub(-1) ~= "\n" then
    s = s .. "\n"
  end

  for line in s:gmatch("(.-)[\r\n]+") do
    if not line:match("^[ 1234567890abcdef]+$") then
      return false
    end
  end

  return true
end

local colours = {}

for n = 1,16 do
  colours[ string.byte("0123456789abcdef", n, n) ] = 2^(n-1)
end

function format.decode(s)
  if s:sub(-1) ~= "\r" and s:sub(-1) ~= "\n" then
    s = s .. "\n"
  end

  local data = {}

  for line in s:gmatch("(.-)[\r\n]+") do
    if line == "" then
      break
    end

    local pixels = {}
    table.insert(data, pixels)
    for pixel in line:gmatch(".") do
      table.insert(pixels, { bg = colours[string.byte(pixel, 1, 1)] })
    end
  end

  return data
end

function format.encode(path)
  -- TODO.
end

return format
