-- Details pane widget

_parent = "agui-container"

function Widget:init(app)
  self.agui_container:init(1, 1, 1, 1)

  self.flex = new('agui-layout', self.agui_container)

  self.agui_widget.main = app

  self.btn_menu = new('agui-button', 1, 2, '  Actions ', 10)
  self.btn_menu:set_enabled(false)

  self.flex:add(self.btn_menu)
  self.flex:add_anchor(self.btn_menu, 'top', 'top', -1, 2)
  self.flex:add_anchor(self.btn_menu, 'left', 'right', -1, -10)
  
  --self.agui_container:add(self.btn_menu)

  local lbl_w = 7

  local function add_label(y, text)
    local lbl = new('agui-label', 1, y, text, lbl_w)
    lbl.agui_widget.bg = 'lightGrey'
    lbl.agui_widget.fg = 'black'

    self.flex:add(lbl)
    self.flex:add_anchor(lbl, "top", "top", -1, y)
    self.flex:add_anchor(lbl, "left", "left", -1, 0)

    local val = new('agui-label', 1, y, "")

    self.flex:add(val)
    self.flex:add_anchor(val, 'left', 'right', lbl, 2)
    self.flex:add_anchor(val, 'top', 'top', -1, y)
    self.flex:add_anchor(val, 'right', 'right', -1, 0)

    return val
  end

  self.pkg_name = new('agui-label', 1, 1, "")
  self.flex:add(self.pkg_name)

  self.flex:add_anchor(self.pkg_name, 'top', 'top', -1, 0)
  self.flex:add_anchor(self.pkg_name, 'left', 'left', -1, 0)
  self.flex:add_anchor(self.pkg_name, 'right', 'right', -1, 0)

  self.pkg_version = add_label(3, "Version")
  self.pkg_repo = add_label(4, "Repo.")
  self.pkg_desc = add_label(5, "Desc.")


  self.pkg_history = new('agui-textbox', 1, 1, 1, 1)

  self.flex:add(self.pkg_history)
  self.flex:add_anchor(self.pkg_history, 'top', 'bottom', -1, 6)
  self.flex:add_anchor(self.pkg_history, 'left', 'left', -1, 0)
  self.flex:add_anchor(self.pkg_history, 'right', 'right', -1, 0)
  self.flex:add_anchor(self.pkg_history, 'bottom', 'bottom', -1, 0)

  self.shown_package = nil

  self.menu = new('kaxui-menu')

  -- TODO: This should be more possible.

  --self.menu.agui_widget.x = w - self.menu.agui_widget.width + 1
  self.menu.agui_widget.y = 2
  self.menu:set_enabled(false)

  self.exit_menu = self.menu:add_option("Close")

  --self.app:add(self.menu)

  self.agui_widget.main.event_loop:subscribe("gui.button.pressed", function(_, id)
    if id == self.exit_menu.agui_widget.id then
      self:hide_menu()
    elseif id == self.btn_menu.agui_widget.id then
      self:show_menu()
    end
  end)

  self.agui_widget.main.event_loop:subscribe("event.http_success", function(_, url, handle)
    if self.shown_package and url == self.shown_package:get_url() .. "/history.txt" then
      self.pkg_history.text = handle.readAll()
    end
  end)

  self.agui_widget.main.event_loop:subscribe("event.http_failure", function(_, url)
    if self.shown_package and url == self.shown_package:get_url() .. "/history.txt" then
      self.pkg_history.text = "Failed to load"
    end
  end)
end

function Widget:show_menu()
  self.agui_container:add(self.menu)
  self.menu.agui_widget.x = self.agui_widget.width - 10

  self.menu:set_enabled(true)

  self.agui_container:select(self.menu)
end

function Widget:hide_menu()
  --self.menu.agui_widget.y = 100
  self.agui_container:remove(self.menu)
  self.menu:set_enabled(false)
  
  self.agui_container.cur_focus = 0
  self.agui_container:focus_next()
end

function Widget:show_package(pkg)
  self.btn_menu:set_enabled(true)

  self.agui_container.cur_focus = 0
  self.agui_container:focus_next()

  self.shown_package = pkg

  self.pkg_name.text = pkg.name

  if pkg.iversion and pkg.iversion < pkg.version then
    self.pkg_version.text = pkg.iversion .. " (Upgrade: " .. pkg.version .. ")"
  else
    self.pkg_version.text = pkg.version .. ""
  end

  self.pkg_repo.text = pkg.repo.url
  if pkg.description ~= "" then
    self.pkg_desc.text = pkg.description
  else
    self.pkg_desc.text = pkg.short_desc
  end


  self.pkg_history.text = "Loading..."

  http.request(pkg:get_url() .. "/history.txt")
end

function Widget:key(key)
  -- Do Nothing when we have no package.  
  if not self.shown_package then
    return false
  end

  if self.agui_container:key(key) then
    return true
  elseif key == keys.m then
    self:show_menu()

    return true
  end
end

function Widget:draw(canvas, theme)
  if self.shown_package then
    self.agui_container:draw(canvas, theme)
  else
    canvas:clear()

    local msg = "Select a package."

    canvas:move(math.floor(canvas.width / 2 - #msg / 2), math.floor(canvas.height / 2))
    canvas:write(msg)
  end
end   
