-- lint-mode: veek-interface

--- Interface for reading from things.
-- @interface veek-read-handle

_parent = "interface"

function Object:init()
end

--- Returns the rest of the object at once.
-- @treturn veek-string The string.
function Object:all()
end

--- Returns a single line.
-- @treturn veek-string The line it's read.
function Object:read_line()
end

--- Returns a line iterator.
-- @treturn iterator An iterator of all the lines in the object.
function Object:lines()
end

--- Closes this handle, preventing it from being used again.
function Object:close()
end
