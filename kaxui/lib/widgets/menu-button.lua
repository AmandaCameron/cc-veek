_parent = 'agui-button'

function Widget:init(y, label)
  self.agui_button:init(1, y, label) 

  self.agui_widget:add_flag('buffered')
end

function Widget:draw(c, t)
  local lbl = self.agui_label.text

  if #lbl > self.agui_widget.width then
    lbl = lbl:sub(1, self.agui_widget.width-3) .. "..."
  else
    local padding = math.floor(self.agui_widget.width / 2 - #lbl / 2)

    lbl = string.rep(" ", padding) .. lbl .. string.rep(" ", padding)
  end


  c:move(1, 1)
  c:write(lbl)
end