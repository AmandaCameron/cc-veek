local format = {}

function format.is_a(s)
  for line in s:gmatch("(.+)\r?\n") do
    if not line:match("^[ 0123456789abcdef" .. string.char(31) .. string.char(30) .."]+$") then
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
  local data = {}

  for line in s:gmatch("(.+)\r?\n") do
    local pixels = {}

    local state = 0

    local fg = colours[string.byte("0")]
    local bg = colours[string.byte("f")]

    for char in line:gmatch(".") do
      if char == string.char(30) then
        state = 1

      elseif char == string.char(31) then
        state = 2

      elseif state == 1 then
        bg = colours[string.byte(char)]

        state = 0
      elseif state == 2 then
        fg = colours[string.byte(char)]
 
        state = 0
      elseif state == 0 then
        pixels[#pixels + 1] = {
          fg = fg,
          bg = bg,
          text = char,
        }
      end
    end

    data[#data + 1] = pixels
  end

  return data
end

function format.encode(image)
  -- TODO
end

return format