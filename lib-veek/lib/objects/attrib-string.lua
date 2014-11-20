--- Attributed string. Allows storing specified attributes on the given string.
-- @parent veek-string
-- @classmod veek-attrib-string

-- lint-mode: veek-object

_parent = "veek-string"

--- Initalises a veek-attrib-string with the given body.
-- @tparam ?|string|veek-string body The body to initalise with.
function Object:init(body)
  self.veek_string:init(body)

  self.format = {}
end

--- Appends {other} to this string.
-- @tparam string|veek-string|veek-attrib-string other The other string to append.s
-- @treturn veek-attrib-string This string, to allow chaining.
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

--- Iterates this string, splitting by needle.
-- @tparam veek-string|string needle The string to split by.
-- @treturn iterator Iterator of sub-strings of this string.
function Object:split(needle)
  local parts = {}
  local idx, iend = self:index_of(needle)
  local str = self

  local function ret()
    if type(idx) == "number" then
      local part = str:substring(1, idx - 1)
      str = str:substring(idx + 1)

      idx = str:index_of(needle)

      return part
    elseif not idx then
      idx = "done"

      return str
    end
  end

  return ret
end

--- Returns a sub-string from {start} to {stop}
-- @int start The starting position.
-- @int? stop The end position.
-- @treturn veek-attrib-string The sub-string.
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

--- Renders this string to the given canvas, with the given default fg and bg.
-- @param c The canvas to render to.
-- @param fg The foreground colour.
-- @param bg The background colour.
function Object:render(c, fg, bg)
  for char, attr in self:iter() do
    c:set_fg(attr.colour or fg)
    c:set_bg(attr.background or bg)

    c:write(char)
  end
end


--- Returns an function for this veek-attrib-string, returning characters paired
-- with their atttributes.
-- @return function of <char, attrib>
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

--- Applys {trans} from {start} to {stop}
-- @tparam function trans The transformation function to use.
-- @int start The starting index.
-- @int stop The ending index.
function Object:apply(trans, start, stop)
  for i = start, stop do
    trans(self.format[i], start - i)
  end
end

--- Applies foreground colour <colour> from start to stop.
-- @param colour The colour to apply.
-- @int start The start position.
-- @int stop The stop position.
function Object:apply_colour(colour, start, stop)
  for i = start, stop do
    if not self.format[i] then
      self.format[i] = {}
    end

    self.format[i].colour = colour
  end
end

--- Applies the given background colour from start to stop.
-- @param colour The colour to apply.
-- @int start The start position.
-- @int stop The stop position.
function Object:apply_background(colour, start, stop)
  for i = start, stop do
    if not self.format[i] then
      self.format[i] = {}
    end

    self.format[i].background = colour
  end
end
