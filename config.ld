-- lint-mode: api
-- lint-ignore-global-get: new_type, add_section

title = "Project Veek"
project = "Project Veek"

merge = true

not_luadoc = true

add_section("event", "Events", "Parameters")

new_type("event", "Events")

file = {
  "lib-agui/lib/base.lua",
  "lib-agui/lib/widgets",
  "lib-agui/lib/objects",

  "agui-images/lib/base.lua",
  "agui-images/lib/widget.lua",
  "agui-images/lib/image.lua",

  "lib-thread",
  "lib-canvas",
  "lib-event",
  "lib-kidven"
}
