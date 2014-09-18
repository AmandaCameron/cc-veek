-- lint-mode: veek-object

_parent = "object"

function Object:init(body)
  self.body = body

  self.format = {}

  for i = 1, #body do
    self.format[i] = {}
  end
end

--- Appends {other} to
function Object:append(other)
  if type(other) == "string" then
    for i in 1, #other do
      self.format[#self.body + i] = {}
    end

    self.body = self.body .. other
  elseif other.is_a and other:is_a("veek-string") then
    for i in 1, #other.body do
      self.format[#self.body + i] = other.format[i]
    end

    self.body = self.body .. other.body
  else
    error("Invalid type.", 2)
  end
end

--- Iterates this veek-string object, returning char, format pairs.
function Object:iter()
  local i = 0

  local function next()
    i = i + 1
    return self.body:gsub(i, i), self.format[i]
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
