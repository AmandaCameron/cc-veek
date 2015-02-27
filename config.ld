-- lint-mode: api
-- lint-ignore-global-get: new_type, add_section

title = "Project Veek"
project = "Project Veek"
description = "Project Veek is a set of utilities for making ComputerCraft apps."

readme = "readme.md"

merge = true

not_luadoc = true

add_section("event", "Events", "Parameters")

new_type("event", "Events")
new_type("widget", "Widgets", true)
new_type("interface", "Interfaces", true)

file = {
  "lib-veek",

  "lib-veek-gui",

  "lib-veek-images/lib/image.lua",
  "lib-veek-images/lib/widget.lua",
}

custom_tags = {
  { 'parent', hidden = true }
}
