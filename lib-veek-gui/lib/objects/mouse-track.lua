--- Tracks the mouse between events for better handling.
-- This is used to keep tabs on the mouse position in several places in
-- Project Veek.
-- @classmod veek-mouse-track

-- lint-mode: kidven

_parent = "object"

function Object:init()
  self.x = 1
  self.y = 1
end

function Object:set(x, y)
  self.x = x
  self.y = y
end

function Object:move(x, y)
  self.x = self.x + x
  self.y = self.y + y
end
