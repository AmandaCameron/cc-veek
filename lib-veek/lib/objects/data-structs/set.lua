-- lint-mode: veek-object

_parent = 'object'

--- Initalises a `veek-set` object.
-- @tparam contents A numerical table of items to start out with.
function Object:init(contents)
	self.contents = {}

	if contents then
		for _, c in ipairs(contents) do
			self:add(c)
		end
	end
end

--- Adds {obj} to us, if we don't already contain it.
-- @param obj The object to add.
function Object:add(obj)
	if not self:contains(obj) then
		self.contents[obj] = true
	end
end

--- Removes {obj} from us.
-- @param obj The object to remove.
function Object:remove(obj)
	self.contents[obj] = nil
end

--- Checks if we contain {obj}
-- @param obj The Object to check if we contain.
-- @treturn bool True if we contain that object, false otherwise.
function Object:contains(obj)
	if self.contents[obj] then
		return true
	end

	return false
end

--- Iterates the set, returning the values we contain.
function Object:iter()
	local function ret(cur)
		return next(self.contents, cur)
	end

	return ret
end

--- Clear this set of all data.
function Object:clear()
	self.contents = {}
end
