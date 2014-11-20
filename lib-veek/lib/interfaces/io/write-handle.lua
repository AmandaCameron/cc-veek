-- lint-mode: veek-interface

--- Interface for a resource you can write to.
-- @interface veek-write-handle

_parent = "interface"

function Object:init()
end

--- Closes the resource.
function Object:close()
end

--- Writes `str` to the resouce.
-- @tparam string|veek-string str The string to write.
function Object:write(str)
end

--- Writes `str` then a linebreak.
-- @tparam string|veek-string str The string to write.
function Object:write_line(str)
end
