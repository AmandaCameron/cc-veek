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

local prog_bar = kidven.new('agui-progress-bar', 2, 4,
prog_win.agui_widget.width - 4)

local prog_text = kidven.new('agui-label', 2, 2,
'Loading...', prog_win.agui_widget.width - 4)

prog_win:add(prog_bar)
prog_win:add(prog_text)

prog_win.agui_widget.x = math.floor(w / 2 - w / 6 * 2)
prog_win.agui_widget.y = math.floor(h / 2) - 3

state:hook("task_begin",
function(id)
  --prog_win.agui_widget.y = math.floor(h / 2 - prog_win.agui_widget.height / 2)
  app:add(prog_win)
  app:select(prog_win)

  prog_bar.format = "%d%%"

  app:draw()
end)

state:hook("task_update",
function(id, detail, cur, max)
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

state:hook("task_complete",
function(id, detail)
  app:select(main)
  app:remove(prog_win)

  app:draw()
end)

-----------------------------------------------------------
-- Available Tab                                         --
-----------------------------------------------------------

function add_available()
  local available_tab = kidven.new('agui-container', 1, 1, w, h - 1)
  main:add_tab('Available', available_tab)

  local package_list = kidven.new('agui-list', 1, 1, 1, 1)
  local details_pane = kidven.new('kaxui-detail-pane', app, 1, 1, 1, 1)

  local flex = kidven.new('agui-layout', available_tab)
  
  flex:add(package_list)
  flex:add(details_pane)

  flex:add_anchor(package_list, 'top', 'top', -1, 0)
  flex:add_anchor(package_list, 'left', 'left', -1, 0)

  if pocket ~= nil then
    flex:add_anchor(package_list, 'right', 'right', -1, 0)
    flex:add_anchor(package_list, 'bottom', 'top', -1, -5)

    local splitter = kidven.new('agui-horiz-seperator', 1, 1, 1)
    flex:add(splitter)

    flex:add_anchor(splitter, 'top', 'bottom', package_list, 0)
    flex:add_anchor(splitter, 'left', 'left', -1, 0)
    flex:add_anchor(splitter, 'right', 'right', -1, 0)

    flex:add_anchor(details_pane, 'top', 'bottom', splitter, 0)
    flex:add_anchor(details_pane, 'left', 'left', -1, 0)
  else
    flex:add_anchor(package_list, 'right', 'middle', -1, 7)
    flex:add_anchor(package_list, 'bottom', 'bottom', -1, 10)


    local splitter = kidven.new('agui-virt-seperator', 1, 1, 1)
    flex:add(splitter)

    flex:add_anchor(splitter, 'left', 'right', package_list, 0)
    flex:add_anchor(splitter, 'top', 'top', -1, 0)
    flex:add_anchor(splitter, 'bottom', 'bottom', -1, 0)

    flex:add_anchor(details_pane, 'left', 'right', splitter, 0)
    flex:add_anchor(details_pane, 'top', 'top', -1, 0)
  end

  flex:add_anchor(details_pane, 'bottom', 'bottom', -1, 0)
  flex:add_anchor(details_pane, 'right', 'right', -1, 0)

  flex:reflow()
  details_pane.flex:reflow()

  app:subscribe("gui.resized",
  function()
    flex:reflow()
    details_pane.flex:reflow()
  end)

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

  local package_list = kidven.new('agui-list', 1, 1, 1, 1)
  local details_pane = kidven.new('kaxui-detail-pane', app, 1, 1, 1, 1)

  local flex = kidven.new('agui-layout', installed_tab)

  flex:add(package_list)
  flex:add(details_pane)


  flex:add_anchor(package_list, 'top', 'top', -1, 0)
  flex:add_anchor(package_list, 'left', 'left', -1, 0)


  if pocket ~= nil then
    flex:add_anchor(package_list, 'right', 'right', -1, 0)
    flex:add_anchor(package_list, 'bottom', 'top', -1, -5)

    local splitter = kidven.new('agui-horiz-seperator', 1, 1, 1)
    flex:add(splitter)

    flex:add_anchor(splitter, 'top', 'bottom', package_list, 0)
    flex:add_anchor(splitter, 'left', 'left', -1, 0)
    flex:add_anchor(splitter, 'right', 'right', -1, 0)

    flex:add_anchor(details_pane, 'top', 'bottom', splitter, 0)
    flex:add_anchor(details_pane, 'left', 'left', -1, 0)
  else
    flex:add_anchor(package_list, 'right', 'middle', -1, 7)
    flex:add_anchor(package_list, 'bottom', 'bottom', -1, 10)


    local splitter = kidven.new('agui-virt-seperator', 1, 1, 1)
    flex:add(splitter)

    flex:add_anchor(splitter, 'left', 'right', package_list, 0)
    flex:add_anchor(splitter, 'top', 'top', -1, 0)
    flex:add_anchor(splitter, 'bottom', 'bottom', -1, 0)

    flex:add_anchor(details_pane, 'left', 'right', splitter, 1)
    flex:add_anchor(details_pane, 'top', 'top', -1, 0)
  end

  flex:add_anchor(details_pane, 'bottom', 'bottom', -1, 0)
  flex:add_anchor(details_pane, 'right', 'right', -1, 0)

  flex:reflow()
  details_pane.flex:reflow()


  app:subscribe("gui.resized",
  function()
    flex:reflow()
    details_pane.flex:reflow()
  end)

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

  app:subscribe("gui.button.pressed", 
  function(_, id)
    if id == btn_reload.agui_widget.id then
      app.pool:new(
      function() 
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
app:subscribe("gui.resized",
function()
  main:resize(term.getSize())
end)

add_available()
add_installed()
add_settings()

app:add(main)
app:add(prog_win)


app:subscribe("program.start", 
function()
  app.pool:new(
  function() 
    for _, repo in pairs(state.repos) do
      repo:update()
    end

    app:trigger("kaxui.data.load")
    app:draw()
  end)
end)

-- Hook events.

app:main()
