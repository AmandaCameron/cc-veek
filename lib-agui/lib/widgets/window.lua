_parent = 'agui-container'

function Widget:init(title, width, height)
  self.agui_container:init(1, 1, width + 2, height + 2)

  self.title = title

  self.agui_widget.fg = 'window-body-fg'
  self.agui_widget.bg = 'window-body-bg'

  self.title_fg = 'window-title-fg'
  self.title_bg = 'window-title-bg'

  self.flags = {}
end

function Widget:clicked(x, y, btn)
  self.moving = false
  self.resizing = false

  self.mouse_x = x
  self.mouse_y = y

  if y == 1 then
    local close = 3
    local minimise = 4
    local maximise = 5

    if not self.flags.closable then
        close = -1
        minimise = minimise - 1
        maximise = maximise - 1
    end

    if not self.flags.minimisable then
        minimise = -1
        maximise = maximise - 1
    end

    if not self.flags.maximisable then
        maximise = -1
    end

    if x == close then
        self.agui_widget:trigger('gui.window.closed')
    elseif x == minimise then
        self.agui_widget:trigger('gui.window.minimised')
    elseif x == maximise then
        self.agui_widget:trigger('gui.window.maximised')
    else
        self.moving = true
    end
  elseif x == self.agui_widget.width and y == self.agui_widget.height and self.flags.resizable then
    self.resizing = true
  else
    self.agui_container:clicked(x - 1, y - 1, btn)
  end
end

function Widget:dragged(x_del, y_del, button)
  if self.moving then
    self.agui_widget.x = self.agui_widget.x + x_del
    self.agui_widget.y = self.agui_widget.y + y_del
  elseif self.resizing then
    self.agui_widget:resize(self.agui_widget.width + x_del, self.agui_widget.height + y_del)

    self.agui_widget:trigger('gui.window.resize')
  else
    self.agui_container:dragged(x_del, y_del, button)
  end
end

function Widget:blur()
  self.agui_widget:trigger('gui.window.blur')

  self.agui_container:blur()
end

function Widget:focus()
  self.agui_widget:trigger('gui.window.focus')

  self.agui_container:focus()
end

function Widget:draw(pc, theme)
  local lbl = self.title

  if #lbl > self.agui_widget.width - 9 then
      lbl = string.sub(lbl, self.agui_widget.width - 13) .. "..."
  end

  pc:move(1, 1)
  pc:set_fg('window-border-fg')
  pc:set_bg('window-border-bg')

  pc:write("+" .. string.rep("-", pc.width - 2) .. "+")

  for y=2,pc.height-1 do
      pc:move(1, y)
      pc:write("|")

      pc:move(pc.width, y)
      pc:write("|")
  end

  pc:move(1, pc.height)
  pc:write("+" .. string.rep("-", pc.width - 2) .. "+")


  pc:set_bg('window-title-bg')
  pc:set_fg('window-title-fg')

  pc:move(math.floor(pc.width / 2 - #lbl / 2), 1)
  pc:write("[ " .. lbl .. " ]")

  -- Draw the controls, batman!

  pc:move(2, 1)

  pc:set_fg('window-controls-fg')
  pc:set_bg('window-controls-bg')
  pc:write('[')

  if self.flags.closable then
      pc:set_fg('window-close-fg')
      pc:set_bg('window-close-bg')
      pc:write('X')
  end

  if self.flags.minimisable then
      pc:set_fg('window-minimise-fg')
      pc:set_bg('window-minimise-bg')
      pc:write('-')
  end

  if self.flags.maximisable and self.flags.resizable then
      pc:set_fg('window-maximise-fg')
      pc:set_bg('window-maximise-bg')
      pc:write("+")
  end

  pc:set_fg('window-controls-fg')
  pc:set_bg('window-controls-bg')
  pc:write(']')

  if self.flags.resizable then
      pc:move(self.agui_widget.width, self.agui_widget.height)
      pc:set_fg('window-resize-fg')
      pc:set_bg('window-resize-bg')
      pc:write("/")
  end

  -- Draw the contents! :o

  local c = pc:sub(2, 2, pc.width - 2, pc.height - 2)

  c:set_bg(self.agui_widget.bg)
  c:set_fg(self.agui_widget.fg)

  self.agui_container:draw(c, theme)
end
