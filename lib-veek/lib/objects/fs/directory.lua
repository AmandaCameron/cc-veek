--- Represents a directory on the filesystem.
-- @classmod veek-directory

-- lint-mode: veek-object

_parent = 'object'
_implements = {
  'veek-fs-node'
}

--- Initalises the object with the given path.
-- @tparam string path
function Object:init(path)
  self.path = path
end

--- Returns true if this directory exists.
-- @treturn bool True if this directory exists.
function Object:exists()
  return fs.exists(self.path)
end

--- Creates this directory.
function Object:create()
  fs.makeDir(self.path)
end

--- Iterates the given directory, returning either a `veek-directory` or `veek-file`.
-- @treturn iterator An iterator of the files and directories in the this directory.
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
