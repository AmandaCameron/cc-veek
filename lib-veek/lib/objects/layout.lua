-- lint-mode: kidven

_parent = "object"

function Object:init(text, width, height)
  kidven.verify({ text, width, height }, 'text', 'number?', 'number?')

  self.ellipsis = false
  self.wrap = true

  self.width = width or 20
  self.height = height or -1

  self.text = text or ""

  self.align = 'left'
  self.line_cache = {}
end

function Object:get_size()
  if self.height ~= -1 then
    return self.width, self.height
  end

  return self.width, #self.line_cache
end

function Object:set_text(text)
  self.text = text

  self:reflow()
end

function Object:resize(w, h)
  self.width = w
  self.height = h

  self:reflow()
end

function Object:fit(obj)
  if not (obj.width and obj.height) then
    error("Object to fit to must have both width and height attributes.", 2)
  end

  self.width = obj.width
  self.height = obj.height

  self:reflow()
end

function Object:reflow()
  self.line_cache = {}

  local x = 1
  local line = 1

  for word in self.text:gmatch('%S-%s') do
    if x + #word > self.width then
      if self.wrap then
        if self.height == -1 or (self.height ~= -1 and line < self.height) then
          x = 1
          line = line + 1
        elseif self.height ~= -1 then
          if self.ellipsis then
            self.line_cache[line] = self.line_cache[line] .. word:sub(1, self.width - x - 3) .. "..."
          end
        end
      elseif x < self.width then
        x = self.width

        if self.ellipsis then
            self.line_cache[line] = self.line_cache[line] .. word:sub(1, self.width - x - 3) .. "..."
        end
      end
    end

    self.line_cache[line] = self.line_cache[line] .. word:gsub('\n', '')

    if word:sub(-1) == '\n' then
      x = self.width
    end
  end
end

function Object:render(canvas, x_off, y_off)
  x_off = x_off or 1
  y_off = y_off or 1

  local height = self.height

  if height == -1 then
    height = canvas.height - y_off
  end

  local c = Object:sub(x_off, y_off, self.width, height)

  for y, line in ipairs(self.line_cache) do
    c:move(1, y)

    if self.align == 'right' then
      c:write((' '):rep(c.width - #line))
    elseif self.align == 'center' then
      c:write((' '):rep(math.floor(c.width - #line / 2)))
    end

    c:write(line)
    c:write((' '):rep(c.width - canvas.x))
  end
end
