-- lint-mode: veek-object

_parent = "veek-string"

function Object:init(body)
  self.veek_string:init(body)

  self.format = {}

  for i = 1, #body do
    self.format[i] = {}
  end
end

function Object:append(other)
  if type(other) == "string" then
    for i in 1, #other do
      self.format[#self.veek_string.body + i] = {}
    end

    self.veek_string.body = self.veek_string.body .. other
  elseif other.is_a and other:is_a("veek-string") then
    self:append(other.body)
  elseif other.is_a and other:is_a("veek-attrib-string") then
    for i in 1, #other.body do
      self.format[#self.veek_string.body + i] = other.format[i]
    end

    self.veek_string.body = self.veek_string.body .. other.body
  else
    error("Invalid type.", 2)
  end
end

--- Iterates this veek-string object, returning char, format pairs.
function Object:iter()
  local i = 0

  local function next()
    i = i + 1

    return self.veek_string.body:sub(i, i), self.format[i]
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
    self.format[i].colour = colour
  end
end

function Object:apply_background(colour, start, stop)
  for i = start, stop do
    self.format[i].background = colour
  end
end
