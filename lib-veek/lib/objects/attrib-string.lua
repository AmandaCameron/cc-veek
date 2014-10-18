-- lint-mode: veek-object

_parent = "veek-string"

function Object:init(body)
  self.veek_string:init(body)

  self.format = {}
end

function Object:append(other)
  if type(other) == "string" then
    for i = 1, #other do
      self.format[self:length() + i] = {}
    end

    self.veek_string:append(other)
  elseif other.is_a and other:is_a("veek-attrib-string") then
    for i = 1, other:length() do
      self.format[self:length() + i] = other:cast('veek-attrib-string').format[i]
    end

    self.veek_string.body = self.veek_string.body .. other:cast('veek-string').body
  elseif other.is_a and other:is_a("veek-string") then
    return self:append(other.body or '')
  else
    error("Invalid type.", 2)
  end

  return self
end

function Object:split(needle)
  local parts = {}
  local idx = self:index_of(needle)
  local str = self

  while idx do
    parts[#parts + 1] = str:substring(1, idx - 1)
    str = str:substring(idx + #needle)

    idx = str:index_of(needle)
  end

  parts[#parts + 1] = str

  return ipairs(parts)
end

function Object:substring(start, stop)
  if not stop then
    stop = self:length()
  elseif stop < 0 then
    stop = self:length() + stop + 1
  end

  local ret = new('veek-attrib-string', self.veek_string:substring(start, stop):string())

  for i = start, stop do
    ret.format[i - start + 1] = self.format[i]
  end

  return ret
end

-- Draw to the screen.

function Object:render(c, fg, bg)
  for char, attr in self:iter() do
    c:set_fg(attr.colour or fg)
    c:set_bg(attr.background or bg)

    c:write(char)
  end
end


--- Iterates this veek-string object, returning char, format pairs.
function Object:iter()
  local i = 0

  local function next()
    i = i + 1

    if i <= self:length() then
      return self.veek_string.body:sub(i, i), self.format[i] or {}
    end
  end

  return next
end

function Object:apply(trans, start, stop)
  for i = start, stop do
    trans(self.format[i], start - i)
  end
end

function Object:apply_colour(colour, start, stop)
  for i = start, stop do
    if not self.format[i] then
      self.format[i] = {}
    end

    self.format[i].colour = colour
  end
end

function Object:apply_background(colour, start, stop)
  for i = start, stop do
    if not self.format[i] then
      self.format[i] = {}
    end

    self.format[i].background = colour
  end
end
