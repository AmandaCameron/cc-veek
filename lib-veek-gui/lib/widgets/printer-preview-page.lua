-- lint-mode: veek-widget

_parent = "veek-list-item"

function Widget:init(num)
  self.veek_list_item:init("Page " .. num)

  self.veek_widget.height = 21

  local fakeTerm = {}

  function fakeTerm.getSize()
    return 24, 21
  end

  function fakeTerm.isColour()
    return false
  end

  self.canvas = canvas.new(fakeTerm, function(c) return c end, 24, 21, true)
end
