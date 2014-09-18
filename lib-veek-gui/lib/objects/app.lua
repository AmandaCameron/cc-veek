--- App Object, encapsolating the main loop, and all the app's threads.
-- @parent event-loop
-- @classmod veek-apps

--------
-- Main Window Resized.
-- @event gui.resized

--------
-- Child Window Resized.
-- @event window.resized
-- @string window_id The ID of the window that's been resized.

-- lint-mode: veek-object

_parent = 'event-loop'

-- Helper function for theme loading.

local function load_base_theme(fname)
  local ret = {}

  ret.colours = {
    ['screen-bg'] = 'black',
    ['screen-fg'] = 'white',
  }

  -- TODO: Change these to match a different format.
  for n, col in pairs(colours) do
    if type(col) == "number" then
      ret.colours[n] = col
    end
  end

  local f = fs.open(fname, "r")

  if not f then
    error("Can not open theme: " .. fname, 2)
  end

  local data = textutils.unserialize(f.readAll())

  f.close()

  for n, val in pairs(data.colours) do
    ret.colours[n] = val
  end

  return ret
end

-- Object itself.

--- Initialise an veek-app object.
-- @tparam ?|term display A term.redirect capable display object, or nil for term.
function Object:init(display)
  display = display or term

  if display.current then
    display = display.current()
  end

  self.event_loop:init()

  self.pool = new('thread-pool')

  local hooks = {}

  function hooks.die(_)
    self.pool:stop()
  end

  function hooks.error(_, err)
    self.main_err = err
  end

  self.pool:new(function()
    self.event_loop:main()
  end, hooks)

  self.screens = {}

  -- TODO: This should use the veek-window object to abstract... stuff?
  self.main_window = new('veek-app-window', self, display)
  self.main_window.id = 'main-window'
  self.main_window.gooey.veek_widget.fg = 'screen-fg'
  self.main_window.gooey.veek_widget.bg = 'screen-bg'

  --table.insert(self.screens, self.main_window)

  self.screens['main-window'] = self.main_window

  if display.isColour and display.isColour() then
    self.theme = load_base_theme('__CFG__/veek/themes/colour')
  else
    self.theme = load_base_theme('__CFG__/veek/themes/no_colour')
  end

  self:load_theme("__CFG__/veek/themes/user")

  self.mouse = new('veek-mouse-track')

  self.event_loop:subscribe("event.mouse_click", function(_, btn, x, y)
    local ok, err = pcall(function()
      self.screens[self:active_window()].gooey:clicked(x, y, btn)
    end)

    self.mouse:set(x, y)

    if not ok then
      self.main_err = err
      self:quit()
    end
  end)

  self.event_loop:subscribe("event.mouse_drag", function(_, btn, x, y)
    local ok, err = pcall(function()
      self.screens[self:active_window()].gooey:dragged(x - self.mouse.x, y - self.mouse.y, btn)
    end)

    self.mouse:set(x, y)

    if not ok then
      self.main_err = err
      self:quit()
    end
  end)

  self.event_loop:subscribe("event.mouse_scroll", function(_, dir, x, y)
    local ok, err = pcall(function()
      self.screens[self:active_window()].gooey:scroll(x, y, dir)
    end)

    self.mouse:set(x, y)

    if not ok then
      self.main_err = err
      self:quit()
    end
  end)

  self.event_loop:subscribe("event.key", function(_, k)
    local ok, err = pcall(function()
      self.screens[self:active_window()].gooey:key(k)
    end)

    if not ok then
      self.main_err = err
      self:quit()
    end
  end)

  self.event_loop:subscribe("event.char", function(_, c)
    local ok, err = pcall(function()
      self.screens[self:active_window()].gooey:char(c)
    end)

    if not ok then
      self.main_err = err
      self:quit()
    end
  end)

  local resize_func = function(_, win)
    if not win then
      win = 'main-window'
    end

    local w, h = self.screens[win].display.getSize()

    self.screens[win].canvas.width = w
    self.screens[win].canvas.height = h

    self.screens[win].gooey:resize(w, h)

    self:trigger('window.resize', win)

    if win == 'main-window' then
      self:trigger('gui.resized')
    end
  end

  self.event_loop:subscribe('event.window_resize', resize_func)

  self.event_loop:subscribe('event.term_resize', function(e)
    resize_func(e, self:active_window())
  end)

  self.event_loop:subscribe('event.window_close', function()
    local win = self:active_window()

    self:trigger('window.closed', win)
  end)

  self.event_loop:subscribe("event.*", function()
    self:draw()
  end)

  self.event_loop:subscribe('program.start', function()
    self:draw()
  end)
end

--- Draws the app to it's terminal.
function Object:draw()
  for _, screen in pairs(self.screens) do
    screen:draw()
  end
end

--- Runs the main loop.
function Object:main()
  self.main_window.display.clear()

  self.main_window.gooey.cur_focus = 0
  self.main_window.gooey:focus_next()

  local ok, err = pcall(function()
    self.pool:main()
  end)


  self.main_window.display.setBackgroundColour(colours.black)
  self.main_window.display.setTextColour(colours.white)
  self.main_window.display.clear()
  self.main_window.display.setCursorPos(1, 1)

  if not ok then
    printError('Thread pool error: ' .. err)
  end

  if self.main_err then
    printError('Main Loop error: ' .. self.main_err)
  end
end

-- Other Helpers.

--- Kills the main loop.
function Object:quit()
  self.event_loop:stop()
end

-- Window API!

--- Gets the currently-active window.
-- @treturn string The window ID of the active window.
function Object:active_window()
  if self.main_window.display.activeWindow then
    return self.main_window.display.activeWindow()
  end

  return 'main-window'
end

--- Create a new window.
-- @string title The window's title.
-- @int width The window's width.
-- @int height The window's height.
-- @treturn veek-app-widnow The app window that was created.
function Object:new_window(title, width, height)
  if self.main_window.display.newWindow then
    local id, t = self.main_window.display.newWindow(title, width, height)

    local window = new('veek-app-window', self, t)

    window.id = id

    self.screens[id] = window

    return window
  else
    local window = new('veek-virtual-window', self, title, width, height)

    window.id = 'virtual-' .. window.veek_app_window.gooey.veek_widget.id

    return window
  end
end

-- GUI Helpers.

--- Select a widget in the main window.
-- @tparam veek-widget|int view
function Object:select(view)
  self.main_window:select(view)
end

--- Add a widget in the main window.
-- @tparam veek-widget view
function Object:add(view)
  self.main_window:add(view)
end

--- Remove a widget from the main window.
-- @tparam veek-widget|int view
function Object:remove(view)
  self.main_window:remove(view)
end

-- Theme Stuff.

--- Load the given theme into the graphics stack.
-- @string fname
function Object:load_theme(fname)
  local f = fs.open(fname, "r")

  if not f then
    return false, "Could not open " .. fname
  end

  local theme = textutils.unserialize(f.readAll())

  if theme.base then
    self:load_theme(theme.base)
  end

  self:merge_theme(theme)
end

function Object:merge_theme(theme)
  if theme.colours then
    for n, c in pairs(theme.colours) do
      self.theme.colours[n] = c
    end
  end
end

function Object:lookup(name)
  if self.theme.colours[name] == nil then
    if name:match('-bg$') then
      return self:lookup('screen-bg')
    elseif name:match('-fg$') then
      return self:lookup('screen-fg')
    elseif name == "transparent" then
      return nil
    else
      error("Invalid colour " .. name, 2)
    end
  end


  if type(self.theme.colours[name]) == 'string' then
    return self:lookup(self.theme.colours[name]) -- TODO: Loop Checking.
  end

  return self.theme.colours[name]
end
