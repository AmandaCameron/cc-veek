-- lint-mode: veek-object

_parent = 'object'
_implements = {
  'veek-fs-node'
}

function Object:init(path)
  self.path = path
end

function Object:exists()
  return fs.exists(self.path)
end

function Object:create()
  fs.makeDir(self.path)
end

function Object:iter()
  local list = fs.list(self.path)
  local i = 0

  local function ret()
    i = i + 1


    if list[i] then
      local node = fs.combine(self.path, list[i])

      if fs.isDir(node) then
        return new('veek-directory', node)
      else
        return new('veek-file', node)
      end
    end
  end

  return ret
end
