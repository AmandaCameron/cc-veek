-- lint-mode: veek-object

--_parent = "veek-read-handle"
_parent = "object"
_implements = { 
  "veek-read-handle"
}

function Object:init(handle)
  self.handle = handle
end

function Object:all()
  return new('veek-string', self.handle.readAll())
end

function Object:read_line()
  return new('veek-string', fs.readLine(self.handle))
end

function Object:lines()
  local function ret()
    return self:read_line()
  end

  return ret
end

function Object:close()
  self.handle.close()
end
