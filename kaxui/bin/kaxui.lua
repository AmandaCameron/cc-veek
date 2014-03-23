os.loadAPI("__LIB__/acg/acg")

local state = acg.load_state()

os.loadAPI("__LIB__/kaxui/kaxui")
os.loadAPI("__LIB__/agui/agui") 

local w, h = term.getSize()

local app = kidven.new('agui-app')

local main = kidven.new('agui-tab-bar', 1, 1, w, h)

-----------------------------------------------------------
-- Output Redirection                                    --
-----------------------------------------------------------

local prog_win = kidven.new('agui-window', 'Progress', w / 3 * 2, 5)

local prog_bar = kidven.new('kaxui-progress-bar', 2, 3,
  prog_win.agui_widget.width - 4)

local prog_text = kidven.new('agui-label', 2, 2,
  'Loading...', prog_win.agui_widget.width - 4)

prog_win:add(prog_bar)
prog_win:add(prog_text)

prog_win.agui_widget.x = w / 2 - w / 6 * 2
prog_win.agui_widget.y = 100

state:hook("task_begin", function(id)
  prog_win.agui_widget.y = math.floor(h / 2 - prog_win.agui_widget.height / 2)
  prog_bar.format = "%d%%"

  app:draw()
end)

state:hook("task_update", function(id, detail, cur, max)
  prog_text.text = detail
  
  if max > 0 then
    prog_bar.progress = cur / max
    prog_bar.format = "%d%%"
  else
    prog_bar.progress = 0
    prog_bar.format = cur .. " / ??"
  end

  app:draw()
end)

state:hook("task_complete", function(id, detail)
  prog_win.agui_widget.y = 100

  app:draw()
end)

-----------------------------------------------------------
-- Available Tab                                         --
-----------------------------------------------------------

function add_available()
  local available_tab = kidven.new('agui-container', 1, 1, w, h - 1)
  main:add_tab('Available', available_tab)

  local package_list = kidven.new('agui-list', 1, 1, math.floor(w / 3.5) - 1, h - 1)

  local details_pane = kidven.new('kaxui-detail-pane', app, math.floor(w / 3.5) + 1, 1, w - package_list.agui_widget.width - 1, h - 1)

  available_tab:add(package_list)
  available_tab:add(kidven.new('agui-virt-seperator', math.floor(w / 3.5), 1, h - 1))
  available_tab:add(details_pane)

  local install_opt = details_pane.menu:add_option("Install")

  app:subscribe("gui.button.pressed", function(_, id)
    if id == install_opt.agui_widget.id then
      details_pane:hide_menu()

      app.pool:new(function()
        state:install(details_pane.shown_package.name)

        state:save()
        
        app:trigger("kaxui.data.load")
      end)
    end
  end)

  app:subscribe("kaxui.data.load", function()
    available_tab:select(package_list)

    package_list.items = {}

    for _, pkg in pairs(state:get_packages()) do
      if pkg.state == "available" then
        package_list:add(kidven.new('kaxui-pkg-list-item', pkg))
      end
    end
  end)

  app:subscribe("gui.list.changed", function(_, id, itemid, item)
    if id == package_list.agui_widget.id then
      details_pane:show_package(item.pkg)
    end
  end)
end

-----------------------------------------------------------
-- Installed Tab                                         --
-----------------------------------------------------------

local function add_installed()
  local installed_tab = kidven.new('agui-container', 1, 1, w, h - 1)
  main:add_tab("Installed", installed_tab)

  local package_list = kidven.new('agui-list', 1, 1, math.floor(w / 3.5) - 1, h - 1)

  local details_pane = kidven.new('kaxui-detail-pane', app, math.floor(w / 3.5) + 1, 1, w - math.floor(w / 3.5), h - 1)

  installed_tab:add(package_list)
  installed_tab:add(kidven.new('agui-virt-seperator', math.floor(w / 3.5), 1, h - 1))
  installed_tab:add(details_pane)


  local reinstall_opt = details_pane.menu:add_option("Reinstall")
  local update_opt = details_pane.menu:add_option("Update")
  local remove_opt = details_pane.menu:add_option("Remove")

  app:subscribe("gui.button.pressed", function(_, id)
    if id == reinstall_opt.agui_widget.id then
      details_pane:hide_menu()

      app.pool:new(function()
        state:install(details_pane.shown_package.name)
        state:save()
      end)
    elseif id == update_opt.agui_widget.id then
      details_pane:hide_menu()

      app.pool:new(function()
        state:install(details_pane.shown_package.name)
        state:save()

        app:trigger("kaxui.data.load")
      end)
    elseif id == remove_opt.agui_widget.id then
      details_pane:hide_menu()

      app.pool:new(function()
        state:remove(details_pane.shown_package.name)
        state:save()

        app:trigger("kaxui.data.load")
      end)
    end
  end)

  app:subscribe("kaxui.data.load", function()
    installed_tab:select(package_list)

    package_list.items = {}
    
    for _, pkg in pairs(state:get_packages()) do
      if pkg.state == "installed" or pkg.state == "update" then
        package_list:add(kidven.new('kaxui-pkg-list-item', pkg))
      end
    end
  end)

  app:subscribe("gui.list.changed", function(_, id, itemid, item)
    if id == package_list.agui_widget.id then
      update_opt:set_enabled(item.pkg.state == "update")

      details_pane:show_package(item.pkg)
    end
  end)
end

-----------------------------------------------------------
-- Misc Settings
-----------------------------------------------------------

local function add_settings()
  local settings = kidven.new('agui-container', 1, 1, w, h - 1)
  main:add_tab("Settings", settings)

  local menu = kidven.new('kaxui-menu')
  settings:add(menu)

  local btn_reload = menu:add_option('Reload')
  local btn_exit = menu:add_option('Exit')

  btn_exit.agui_widget.fg = "exit-button--fg"
  btn_exit.agui_widget.bg = "exit-button--bg"

  menu.agui_widget.x = math.floor(w / 2) - 5
  menu.agui_widget.y = math.floor(h / 2) - math.floor(menu.agui_widget.height / 2)

  settings:select(menu)

  app:subscribe("gui.button.pressed", function(_, id)
    if id == btn_reload.agui_widget.id then
        app.pool:new(function() 
          for _, repo in pairs(state.repos) do
            repo:update()
          end

          app:trigger("kaxui.data.load")
        end)
    elseif id ==  btn_exit.agui_widget.id then
      app:quit()
    end
  end)
end


-- Setup the main GUI

add_available()
add_installed()
add_settings()

app:add(main)
app:add(prog_win)

app:subscribe("program.start", function()
  app.pool:new(function() 
    for _, repo in pairs(state.repos) do
      repo:update()
    end

    app:trigger("kaxui.data.load")
  end)
end)

-- Hook events.

app:main()