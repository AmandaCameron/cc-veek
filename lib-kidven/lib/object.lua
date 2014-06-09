--- Base Kidven Object.
-- This is the base object that all Kidven objects should descend from.
-- @classmod object

-- lint-mode: kidven

-- Object class.

_parent = nil

--- Initalises the Kidven object.
-- This must always be defined for a kidven object to be valid.
-- It is called by kidven.new and the paramaters of it are passed on.
function Object:init()
  -- Does Nothing.
end
