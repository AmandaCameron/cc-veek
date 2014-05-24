-- Progress Bar Widget, stolen and improved from kaxui.
-- Supports indetermenate mode and custom formatting of the
-- middle text.

_parent = "agui-widget"

function Widget:init(x, y, w)
  self.agui_widget:init(x, y, w, 1)

  self.format = "%d%%"
  self.progress = 0
end

function Widget:set_progress(prog)
  if prog < 0 or prog > 1 then
    error("Progress muse be between 0 and 1", 2)
  end

  self.progress = prog
end

function Widget:set_indetermenate(ind)
  if ind then
    self.progress = -1
  else
    self.progress = 0
  end
end

function Widget:set_format(fmt)
  self.format = fmt
end

function Widget:draw(canvas, theme)
  if self.progress ~= -1 then
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

    canvas:set_bg("progress-bar-compl-bg")
    canvas:set_fg("progress-bar-compl-fg")
    canvas:write(compl)

    canvas:set_bg("progress-bar-bg")
    canvas:set_fg("progress-bar-fg")
    canvas:write(todo)
  else
    canvas:set_bg("progress-bar-ind-bg")
    canvas:set_fg("progress-bar-ind-fg")
    canvas:write(("/"):rep(canvas.width))
  end
end