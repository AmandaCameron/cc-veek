local format = {}

function format.is_a(path)
  local f = io.open(path, "r")

  for line in f:lines() do
    if not line:match("^[ 1234567890abcdef]+$") then
      f:close()
      return false
    end
  end

  f:close()
  return true
end

local colours = {}

for n = 1,16 do
  colours[ string.byte("0123456789abcdef", n, n) ] = 2^(n-1)
end

function format.decode(path)
  local f = io.open(path, "r")

  local data = {}

  for line in f:lines() do
    local pixels = {}
    table.insert(data, pixels)
    for pixel in line:gmatch(".") do
      table.insert(pixels, { bg = colours[string.byte(pixel, 1, 1)] })
    end
  end

  f:close()

  return data
end

function format.encode(path)
  -- TODO.
end

return format