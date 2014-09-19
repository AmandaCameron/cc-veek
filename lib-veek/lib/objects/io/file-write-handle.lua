-- lint-mode: veek-object

_parent = "veek-write-handle"

function Object:init(handle)
  self.handle = handle
end

function Object:is_open()
  return self.handle ~= nil
end

function Object:write(str)
  if self.handle then
    self.handle.write(str)
  end
end

function Object:write_line(str)
  self:write(str .. "\n")
end

function Object:close()
  if self.handle then
    self.handle.close()
    self.handle = nil
  end
end
