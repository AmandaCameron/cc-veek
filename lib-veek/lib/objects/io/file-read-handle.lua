-- lint-mode: veek-object

--_parent = "veek-read-handle"
_parent = "object"
_implements = { 
  "veek-read-handle"
}

function Object:init(handle)
  if not handle then
    self.valid = false
  else
    self.valid = true
  end

  self.handle = handle
end

function Object:is_valid()
  return self.valid
end

function Object:all()
  if self.valid then
    return new('veek-string', self.handle.readAll())
  end
end

function Object:read_line()
  if self.valid then
    return new('veek-string', fs.readLine(self.handle))
  end
end

function Object:lines()
  local function ret()
    return self:read_line()
  end

  return ret
end

function Object:close()
  if self.valid then
    self.handle.close()
  end
end
