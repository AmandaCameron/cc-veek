-- lint-mode: veek-object

_parent = "veek-read-handle"

function Object:init(handle)
  self.handle = handle
end

function Object:all()
  self.handle.readAll()
end

function Object:read_line()
  return fs.readLine(self.handle)
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
