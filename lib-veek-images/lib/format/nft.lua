local format = {}

function format.is_a(s)
  if s:sub(-1) ~= "\r" and s:sub(-1) ~= "\n" then
    s = s .. "\n"
  end

  local found_colour = false
  for line in s:gmatch("(.-)[\r\n]+") do
    if line:sub(1, 1) ~= string.char(31) and line:sub(1, 1) ~= string.char(30) then
      return false
    end
    
    if line:find(string.char(31)) or line:find(string.char(30)) then
      found_colour = true
    end
  end

  return found_colour
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
    if line == '' then
      break
    end

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
