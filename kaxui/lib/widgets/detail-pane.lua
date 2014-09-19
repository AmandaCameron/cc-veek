-- lint-mode: veek-widget

-- Details pane widget

_parent = "veek-container"

function Widget:init(app)
  self.veek_container:init(1, 1, 1, 1)

  self.flex = new('veek-layout', self.veek_container)

  self.veek_widget.main = app

  self.btn_menu = new('veek-button', 1, 2, 'Actions', 12)
  self.btn_menu:set_enabled(false)

  self.flex:add(self.btn_menu)

  self.flex:add_anchor(self.btn_menu, 'top', 'top', -1, 1)
  self.flex:add_anchor(self.btn_menu, 'left', 'right', -1, -10)

  self.veek_container:add(self.btn_menu)

  local lbl_w = 7

  local function add_label(y, text)
    local lbl = new('veek-label', 1, y, text, lbl_w)
    lbl.veek_widget.bg = 'kaxui-label-bg'
    lbl.veek_widget.fg = 'kaxui-label-fg'

    self.flex:add(lbl)
    self.flex:add_anchor(lbl, "top", "top", -1, y)
    self.flex:add_anchor(lbl, "left", "left", -1, 1)

    local val = new('veek-label', 1, y, "")

    val.veek_widget.bg = 'kaxui-value-bg'
    val.veek_widget.fg = 'kaxui-value-fg'

    self.flex:add(val)

    self.flex:add_anchor(val, 'left', 'right', lbl, 2)
    self.flex:add_anchor(val, 'top', 'top', -1, y)
    self.flex:add_anchor(val, 'right', 'right', -1, 1)

    return val
  end

  local bar = new('veek-widget', 1, 1, 1, 3)
  bar.bg = 'kaxui-title-bg'

  -- Haaaack
  bar.draw = function(_, c)
    c:clear()
  end

  self.flex:add(bar)

  self.flex:add_anchor(bar, 'left', 'left', -1, 0)
  self.flex:add_anchor(bar, 'right', 'right', -1, 0)

  self.pkg_name = new('veek-label', 1, 1, "")

  self.pkg_name.veek_widget.fg = "kaxui-title-fg"
  self.pkg_name.veek_widget.bg = "kaxui-title-bg"

  self.flex:add(self.pkg_name)

  self.flex:add_anchor(self.pkg_name, 'top', 'top', -1, 1)
  self.flex:add_anchor(self.pkg_name, 'left', 'left', -1, 1)
  self.flex:add_anchor(self.pkg_name, 'right', 'right', -1, 12)


  self.pkg_version = add_label(4, "Version")
  self.pkg_repo = add_label(5, "Repo.")
  self.pkg_desc = add_label(6, "Desc.")


  self.pkg_history = new('veek-textbox', 1, 1, 1, 1)

  self.flex:add(self.pkg_history)
  self.flex:add_anchor(self.pkg_history, 'top', 'bottom', -1, -10)
  self.flex:add_anchor(self.pkg_history, 'left', 'left', -1, 1)
  self.flex:add_anchor(self.pkg_history, 'right', 'right', -1, 1)
  self.flex:add_anchor(self.pkg_history, 'bottom', 'bottom', -1, 0)

  self.pkg_history.veek_widget.bg = 'kaxui-label-bg'
  self.pkg_history.veek_widget.fg = 'kaxui-label-fg'

  self.shown_package = nil

  self.menu = new('veek-menu', self.veek_container)

  self.menu:add("Close", function()
    self:hide_menu()
  end)

  app:subscribe("gui.button.pressed", function(_, id)
    if id == self.btn_menu.veek_widget.id then
      self:show_menu()
    end
  end)

  app:subscribe("event.http_success", function(_, url, handle)
    if self.shown_package and url == self.shown_package:get_url() .. "/history.txt" then
      self.pkg_history:set_text(handle.readAll())
    end
  end)

  app:subscribe("event.http_failure", function(_, url)
    if self.shown_package and url == self.shown_package:get_url() .. "/history.txt" then
      self.pkg_history:set_text("No history to show.")
    end
  end)
end

function Widget:resize(w, h)
  self.veek_widget:resize(w, h)

  self.flex:reflow()
end

function Widget:show_menu()
  self.menu:clear()

  self.menu:add("Close", function()
    self:hide_menu()
  end)

  self.menu:add_seperator()

  if self.shown_package == "available" then
    self.menu:add("Install", function()
      self:trigger('kaxui.app.install', self.shown_package)

      self:hide_menu()
    end)
  end

  if self.shown_package.state == "update" then
    self.menu:add("Update", function()
      self:trigger('kaxui.app.install', self.shown_package)

      self:hide_menu()
    end)
  end

  if self.shown_package.state == "installed" or self.shown_package.state == "update" or self.shown_package.state == "orphan" then
    self.menu:add_seperator()

    self.menu:add("Remove", function()
      self:trigger('kaxui.app.uninstall', self.shown_package)

      self:hide_menu()
    end)

    if self.shown_package.state ~= "orphan" then
      self.menu:add("Reinstall", function()
        self:trigger('kaxui.app.reinstall', self.shown_package)

        self:hide_menu()
      end)
    end
  end

  self.menu:show(self.btn_menu.veek_widget.x, self.btn_menu.veek_widget.y)
end

function Widget:hide_menu()
  self.menu:hide()
end

function Widget:show_package(pkg)
  self.btn_menu:set_enabled(true)

  self.veek_container.cur_focus = 0
  self.veek_container:focus_next()

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


  self.pkg_history:set_text("Loading...")

  http.request(pkg:get_url() .. "/history.txt")
end

function Widget:key(key)
  -- Do Nothing when we have no package.
  if not self.shown_package then
    return false
  end

  if self.veek_container:key(key) then
    return true
  elseif key == keys.m then
    self:show_menu()

    return true
  end

  return false
end

function Widget:draw(canvas, theme)
  if self.shown_package then
    self.veek_container:draw(canvas, theme)
  else
    canvas:clear()

    local msg = "Select a package."

    canvas:move(math.floor(canvas.width / 2 - #msg / 2), math.floor(canvas.height / 2))
    canvas:write(msg)
  end
end
