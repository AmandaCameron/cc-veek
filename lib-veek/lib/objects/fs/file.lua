--- Allows OO-like operations on a file in the filesystem.
-- @classmod veek-file

-- lint-mode: veek-object

_parent = "object"
_implements = {
  'veek-fs-node'
}

--- Initalises a new veek-file object with the given path.
-- @string path The path to the file.
function Object:init(path)
  self.path = path
end

--- Returns true if this file exists.
function Object:exists()
  return fs.exists(self.path)
end

--- Opens this file for reading.
-- @treturn veek-file-read-handle The file read object.
function Object:read()
  return new('veek-file-read-handle', fs.open(self.path, 'r'))
end

--- Opens the file for writing.
-- @treturn veek-file-write-handle The file write object.
function Object:write()
  return new('veek-file-write-handle', fs.open(self.path, 'w'))
end
