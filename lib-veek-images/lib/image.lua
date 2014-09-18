--- Image in-memory representation.
-- @parent object
-- @classmod veek-image

-- lint-mode: veek-object

_parent = "object"

-- These are both private, and should not be used.

function Object:init(data)
  self.data = data
end

function Object:lines()
  return ipairs(self.data)
end

--- Render an image to an `Canvas`
-- @tparam Canvas canvas The lib-canvas canvas to render to.
-- @tparam string|int trans The transparency colour.
function Object:render(canvas, trans)
  canvas:push()

  for y, line in ipairs(self.data) do
    for x, pixel in ipairs(line) do
      canvas:move(x, y)
      if pixel.fg then
        canvas:set_fg(pixel.fg)
      end

      if pixel.bg then
        canvas:set_bg(pixel.bg)
      else
        canvas:set_bg(trans)
      end

      if pixel.text then
        canvas:write(pixel.text)
      else
        canvas:write(" ")
      end
    end
  end

  canvas:pop()
end

--- Get the image's size.
-- @treturn int Image's Width
-- @treturn int Image's Height
function Object:size()
  local w, h = 0, 0

  h = #self.data

  for y, line in self:lines() do
    if #line > w then
      w = #line
    end
  end

  return w, h
end
