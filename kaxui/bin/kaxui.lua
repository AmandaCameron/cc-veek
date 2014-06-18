-- @Name: Kaxui
-- @Description: Graphical package manager for ac-get
-- @Author: Amanda Cameron
-- @Icon[4x3]: __LIB__/kaxui/res/icon-4x3

--- Kaxui Graphical Package Manager.
-- Kaxui is a graphical package interface for ac-get. It supports installing
-- uninstalling, and reinstalling packages, as well as looking up the data
-- for them.
--
-- @script kaxui

os.loadAPI("__LIB__/kaxui/kaxui")
os.loadAPI("__LIB__/acg/acg")

local app = kidven.new('agui-app')

if term.isColour() then
  app:load_theme("__LIB__/kaxui/res/theme")
end

local state = acg.load_state()

-- Main Window.

local details_pane = kidven.new('kaxui-detail-pane', app)
local sidebar = kidven.new('kaxui-sidebar', state)

local main = kidven.new('agui-split-pane', sidebar, details_pane)

main.active = 2

if not pocket then
  main.min_pos = 15
  main.max_pos = 15
else
  main.max_pos = 20
end


main.position = main.max_pos

main:update_active()

app:add(main)

main:resize(term.getSize())

app:subscribe('gui.list.changed', function(_, id, iid, item)
  if id == sidebar.package_list.agui_widget.id then
    if item:is_a('kaxui-list-pkg') then
      details_pane:show_package(item.pkg)
    end
  end
end)


-- Loading Window

local loading_win = kidven.new('agui-container', 1, 1, term.getSize())

loading_win.agui_widget.fg = 'black'
loading_win.agui_widget.bg = 'white'

local loading_layout = kidven.new('agui-layout', loading_win)

local loading_prog_bar = kidven.new('agui-progress-bar', 2, 4, 16)
local loading_text = kidven.new('agui-label', 2, 2, 'Loading', 16)

loading_layout:add(loading_text)

loading_layout:add_anchor(loading_text, 'left', 'left', -1, 1)
loading_layout:add_anchor(loading_text, 'top', 'middle', -1, 1)
loading_layout:add_anchor(loading_text, 'right', 'right', -1, 1)

loading_layout:add(loading_prog_bar)

loading_layout:add_anchor(loading_prog_bar, 'left', 'left', -1, 1)
loading_layout:add_anchor(loading_prog_bar, 'top', 'middle', -1, -1)
loading_layout:add_anchor(loading_prog_bar, 'right', 'right', -1, 1)

loading_layout:reflow()

state:hook("task_begin", function(id)
  app:add(loading_win)
  app:remove(main)
  app:select(loading_win)

  loading_prog_bar.format = "%d%%"
  loading_prog_bar.progress = 0

  app:draw()
end)

state:hook("task_update", function(id, detail, cur, max)
  loading_text.text = detail

  if max > 0 then
    loading_prog_bar.format = "%d%%"
    loading_prog_bar:set_progress(cur / max)
  else
    loading_prog_bar.format = cur .. " / ???"
    loading_prog_bar:set_indetermenate(true)
  end

  app:draw()
end)

state:hook("task_complete", function(id, detail)
  app:remove(loading_win)
  app:add(main)
  app:select(main)

  app:draw()
end)

-- Package install/uninstall/etc events.

app:subscribe('kaxui.app.uninstall', function(_, _, pkg)
  app.pool:new(function()
    state:uninstall(pkg.name)

    sidebar:load()

    state:save()
  end)
end)

app:subscribe('kaxui.app.install', function(_, _, pkg)
  app.pool:new(function()
    state:install(pkg.name)

    sidebar:load()

    state:save()
  end)
end)

app:subscribe('kaxui.app.reinstall', function(_, _, pkg)
  app.pool:new(function()
    state:remove(pkg.name)
    state:install(pkg.name)

    sidebar:load()

    state:save()
  end)
end)

-- More events.

app:subscribe('gui.resized', function()
  main:resize(term.getSize())
  loading_win:resize(term.getSize())

  loading_layout:reflow()
end)


app:subscribe("program.start", function()
  app.pool:new(function()
    for _, repo in pairs(state.repos) do
      repo:update()
    end

    sidebar:load()
  end)
end)

app:main()
