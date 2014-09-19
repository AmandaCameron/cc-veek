os.loadAPI("__LIB__/veek/veek")

if not term.isColour() then
  error("This demo requires an advanced computer.")
end

local app = kidven.new("veek-app")

local Widget = {}

function Widget:init()
  self.veek_label:init(1, 1, "Drag Me!")

  self.veek_widget.fg = 'black'
  self.veek_widget.bg = 'white'
end

function Widget:dragged(x_del, y_del, btn)
  self.veek_widget.x = self.veek_widget.x + x_del
  self.veek_widget.y = self.veek_widget.y + y_del

  if self.veek_widget.x < 1 then
    self.veek_widget.x = 1
  end

  if self.veek_widget.y < 1 then
    self.veek_widget.y = 1
  end
end

kidven.register('drag-me', Widget, 'veek-label')

app:add(kidven.new('drag-me'))

app:main()
