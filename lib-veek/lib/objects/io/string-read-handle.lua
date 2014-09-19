-- lint-mode: veek-object

_parent = "veek-read-handle"

function Object:init(str)
  kidven.verify({ str }, "veek-string")

  self.contents = str
end

function Object:all()
  return self.contents:substring(self.pos, -1)
end

function Object:read_line()
  if self.pos >= self.contents:length() then
    return nil
  end

  local pos = self.contents:index_of("\n", self.pos)

  if pos then
    local ret = self.contents:substring(self.pos, pos)

    self.pos = pos + 1
    return ret
  end

  self.pos = self.contents:length()

  return self.contents:substring(self.pos)
end

function Object:lines()
  return function()
    return self:read_line()
  end
end

function Object:close()
  -- Does nothing.

  self.pos = self.contents:length()
end
