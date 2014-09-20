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

function Object:exists()
  return fs.exists(self.path)
end

function Object:read()
  return new('veek-file-read-handle', fs.open(self.path, 'r'))
end

function Object:write()
  return new('veek-file-write-handle', fs.open(self.path, 'w'))
end
