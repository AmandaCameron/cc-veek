-- lint-mode: veek-object

_parent = "object"

function Object:init(data)
  self.data = data
end

function Object:lines()
  return ipairs(self.data)
end

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
