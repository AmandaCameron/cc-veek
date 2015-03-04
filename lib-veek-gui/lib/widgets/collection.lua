_parent = 'veek-container'

function Widget:init(title, w, h)
  self.veek_container:init(1, 1, w + 4, h + 4)

  self.veek_widget.bg = 'collection--bg'
  self.veek_widget.fg = 'collection--fg'

  self.title = title
end

function Widget:draw(canvas)
  canvas:clear()

  canvas:move(1, 1)
  canvas:write(string.rep('-', canvas.width))

  canvas:move(1, canvas.height)
  canvas:write(string.rep('-', canvas.width))

  for y = 1, canvas.height do
    canvas:move(1, y)
    canvas:write("|")

    canvas:move(canvas.width, y)
    canvas:write("|")
  end

  canvas:move(1, 1)
  canvas:write('/')

  canvas:move(canvas.width, 1)
  canvas:write('\\')

  canvas:move(1, canvas.height)
  canvas:write('\\')

  canvas:move(canvas.width, canvas.height)
  canvas:write('/')

  canvas:move(3, 1)
  canvas:write( '[ ' .. self.title .. ' ]')

  local c = canvas:sub(3, 3, canvas.width - 3, canvas.height - 3)
  self:draw_children(c)
end