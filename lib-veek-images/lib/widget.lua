--- Display Widget for veek-image images objects.
-- @parent veek-widget
-- @widget veek-image-widget

-- lint-mode: veek-widget

_parent = "veek-widget"

--- Initalise an veek-image-widget
-- @tparam agi-image img The image to display.
-- @int x The X position of the widget.
-- @int y The Y position of the widget.
-- @int w The widget's width.
-- @int h The widget's height
-- @constructor
function Widget:init(img, x, y, w, h)
  self.veek_widget:init(x, y, w, h)

  self.img = img
end

--- Change the image.
-- @tparam agi-image img
function Widget:set_image(img)
  self.img = img
end

function Widget:draw(canvas)
  local w, h = self.img:size()

  local x_off, y_off = 0, 0

  if w < canvas.width then
    x_off = math.floor(canvas.width / 2 - w / 2)
  elseif w > canvas.width then
    x_off = 0 - math.floor((canvas.width - w) / 2)
  end

  if h < canvas.height then
    y_off = math.floor(canvas.height / 2 - h / 2)
  elseif h > canvas.height then
    y_off = 0 - math.floor((canvas.height - h) / 2)
  end

  canvas:translate(x_off, y_off)
  self.img:render(canvas)
end
