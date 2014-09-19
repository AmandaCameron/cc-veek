--- Window Widget.
-- This is a widget that displays a window inside the main display.
-- This window is constrained to the widget it resides in.
-- @parent veek-container
-- @classmod veek-window

----------
-- veek-window Resized.
-- @event gui.window.resize
-- @int id The window ID.

----------
-- veek-window Close Request.
-- @event gui.window.closed
-- @int id The window ID.

----------
-- veek-window Maximise Request.
-- @event gui.window.maximised
-- @int id The window ID.

----------
-- veek-window Minimise Request.
-- @event gui.window.minimised
-- @int id The window ID.

-- lint-mode: veek-widget

_parent = 'veek-container'

--- Initalise an veek-window
-- @string title The window's title.
-- @int width The content width.
-- @int height The content height.
function Widget:init(title, width, height)
  self.veek_container:init(1, 1, width + 2, height + 2)

  self.title = title

  self.veek_widget.fg = 'window-body-fg'
  self.veek_widget.bg = 'window-body-bg'

  self.title_fg = 'window-title-fg'
  self.title_bg = 'window-title-bg'

  self.flags = {}
end

function Widget:key(kc)
  if kc == keys.f10 then
    local menu = new('veek-menu', self.veek_widget.main)

    menu:add('Move', function()
      self.moving = true

      menu:hide()
    end)

    if self.flags.resizable then
      menu:add('Resize', function()
        self.resizing = true

        menu:hide()
      end)
    end

    menu:add_seperator()

    if self.flags.closable then
      menu:add('Close', function()
        menu:hide()

        self.veek_widget:trigger('gui.window.closed')
      end)
    end

    if self.flags.maximisable then
      menu:add('Maximise', function()
        menu:hide()

        self.veek_widget:trigger('gui.window.maximised')
      end)
    end

    if self.flags.minimisable then
      menu:add('Minimise', function()
        menu:hide()

        self.veek_widget:trigger('gui.window.minimised')
      end)
    end

    menu:show(self.veek_widget.x + 1, self.veek_widget.y + 1)

  -- Resizing Controls
  elseif kc == keys.up and self.resizing then
    self.veek_widget.height = self.veek_widget.height - 1
    self.veek_widget:trigger('gui.window.resize')
  elseif kc == keys.down and self.resizing then
    self.veek_widget.height = self.veek_widget.height + 1
    self.veek_widget:trigger('gui.window.resize')
  elseif kc == keys.left and self.resizing then
    self.veek_widget.width = self.veek_widget.width - 1
    self.veek_widget:trigger('gui.window.resize')
  elseif kc == keys.right and self.resizing then
    self.veek_widget.width = self.veek_widget.width + 1
    self.veek_widget:trigger('gui.window.resize')
  -- Moving Controls
  elseif kc == keys.up and self.moving then
    self.veek_widget.y = self.veek_widget.y - 1
  elseif kc == keys.down and self.moving then
    self.veek_widget.y = self.veek_widget.y + 1
  elseif kc == keys.left and self.moving then
    self.veek_widget.x = self.veek_widget.x - 1
  elseif kc == keys.right and self.moving then
    self.veek_widget.x = self.veek_widget.x + 1
  elseif kc == keys.enter and (self.moving or self.resizing) then
    self.moving = false
    self.resizing = false
  else
    return self.veek_container:key(kc)
  end

  return true
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
        self.veek_widget:trigger('gui.window.closed')
    elseif x == minimise then
        self.veek_widget:trigger('gui.window.minimised')
    elseif x == maximise then
        self.veek_widget:trigger('gui.window.maximised')
    else
        self.moving = true
    end
  elseif x == self.veek_widget.width and y == self.veek_widget.height and self.flags.resizable then
    self.resizing = true
  else
    self.veek_container:clicked(x - 1, y - 1, btn)
  end
end

function Widget:dragged(x_del, y_del, button)
  if self.moving then
    self.veek_widget.x = self.veek_widget.x + x_del
    self.veek_widget.y = self.veek_widget.y + y_del
  elseif self.resizing then
    self.veek_widget:resize(self.veek_widget.width + x_del, self.veek_widget.height + y_del)

    self.veek_widget:trigger('gui.window.resize')
  else
    self.veek_container:dragged(x_del, y_del, button)
  end
end

function Widget:blur()
  self.veek_widget:trigger('gui.window.blur')

  self.veek_container:blur()
  self.veek_widget:blur()
end

function Widget:focus()
  self.veek_widget:trigger('gui.window.focus')

  self.veek_container:focus()
  self.veek_widget:focus()
end

function Widget:draw(pc, theme)
  local lbl = self.title

  if #lbl > self.veek_widget.width - 9 then
      lbl = string.sub(lbl, self.veek_widget.width - 13) .. "..."
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

  if self.veek_widget.focused then
    pc:write("{ " .. lbl .. " }")
  else
    pc:write("[ " .. lbl .. " ]")
  end

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
      pc:move(self.veek_widget.width, self.veek_widget.height)
      pc:set_fg('window-resize-fg')
      pc:set_bg('window-resize-bg')
      pc:write("/")
  end

  -- Draw the contents! :o

  local c = pc:sub(2, 2, pc.width - 2, pc.height - 2)

  c:set_bg(self.veek_widget.bg)
  c:set_fg(self.veek_widget.fg)

  self.veek_container:draw(c, theme)
end
