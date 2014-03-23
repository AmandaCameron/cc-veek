_parent = "agui-widget"

function Widget:init(x, y, w)
  self.agui_widget:init(x, y, w, 1)

  self.format = "%d%%"
  self.progress = 0
end

function Widget:draw(canvas, theme)
  local label = self.format:format(self.progress * 100)

  local lbl_x = math.floor(canvas.width / 2 - #label / 2)

  local compl = string.rep(" ", self.progress * canvas.width)
  local todo = string.rep(" ", (1 - self.progress) * canvas.width)

  if #compl > lbl_x then
    local old_compl = compl .. ""
    compl = compl:sub(1, lbl_x) .. label:sub(1, #compl - lbl_x)
    compl = compl .. string.rep(" ", #old_compl - #compl)
  else
    local old_todo = todo .. ""
    todo = todo:sub(1, lbl_x - #compl) .. label
    todo = todo .. string.rep(" ", #old_todo - #todo)
  end

  canvas:set_bg("white")
  canvas:set_fg("black")
  canvas:write(compl)

  canvas:set_bg("grey")
  canvas:set_fg("white")
  canvas:write(todo)
end