_parent = "agui-container"

function Widget:init(state)
  self.agui_container:init(1, 1, 1, 1)

  self.package_list = new('agui-list', 1, 1, 1, 1)

  self:add(self.package_list)

  self.state = state
end

function Widget:load()
  self.package_list:clear()

  local update = {}
  local installed = {}
  local available = {}

  local task = self.state:begin_task('kaxui::packages::load', 0)

  local packages = self.state:get_packages()
  local i = 0

  for _, pkg in pairs(packages) do
    i = i + 1

    task:update("Processing " .. pkg.name, i)

    if pkg.state == "update" then
      update[#update + 1] = pkg
    elseif pkg.state == "installed" then
      installed[#installed + 1] = pkg
    else
      available[#available + 1] = pkg
    end
  end

  task:done('Processed Packages.')

  if #update > 0 then
    self.package_list:add(new('kaxui-list-header', 'Updates'))
    for _, pkg in ipairs(update) do
      self.package_list:add(new('kaxui-list-pkg', pkg))
    end
  end

  self.package_list:add(new('kaxui-list-header', 'Installed'))

  for _, pkg in ipairs(installed) do
    self.package_list:add(new('kaxui-list-pkg', pkg))
  end

  if #available > 0 then
    self.package_list:add(new('kaxui-list-header', 'Available'))

    for _, pkg in ipairs(available) do
      self.package_list:add(new('kaxui-list-pkg', pkg))
    end
  end
end

function Widget:resize(w, h)
  self.agui_widget:resize(w, h)
  self.package_list:resize(w, h)
end