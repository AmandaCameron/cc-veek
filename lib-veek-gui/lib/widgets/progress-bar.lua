-- lint-mode: veek-widget

--- Progress Bar Widget, stolen and improved from kaxui.
-- Supports indetermenate mode and custom formatting of the
-- middle text.
-- @widget veek-progress-bar

_parent = "veek-widget"


--- Initalises a Progress bar. with the given position and 
-- width.
-- @int x The X position of the widget.
-- @int y The Y position of the widget.
-- @int w The width of the widget.
function Widget:init(x, y, w)
  self.veek_widget:init(x, y, w, 1)

  self.format = "%d%%"
  self.progress = 0
end

--- Sets the current progress.
-- @number prog The progress to set.  Must be betweeen 0 and 1.
function Widget:set_progress(prog)
  if prog < 0 or prog > 1 then
    error("Progress muse be between 0 and 1", 2)
  end

  self.progress = prog
end

--- Sets weather the widget is in intermediate mode or not.
-- @bool ind Weather we should be in intermediate mode or not.
function Widget:set_indetermenate(ind)
  if ind then
    self.progress = -1
  else
    self.progress = 0
  end
end

--- Sets the formatting of the middle label.
-- @string fmt The format string to use. %d will be replaced with the current progress from 0 to 100.
function Widget:set_format(fmt)
  self.format = fmt
end

function Widget:draw(canvas, theme)
  if self.progress ~= -1 then
    local label = self.format:format(self.progress * 100)

    local lbl_x = math.floor(canvas.width / 2 - #label / 2)

    local compl = string.rep(" ", math.ceil(self.progress * canvas.width))
    local todo = string.rep(" ", math.floor((1 - self.progress) * canvas.width))

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
