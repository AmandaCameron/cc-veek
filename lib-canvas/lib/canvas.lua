-- lint-mode: api

-- Canvas API -- Ripped out of agui as it's rather useful
-- on it's own.

local Canvas = {}

-- Public API

function new(...)
  local ret = {}

  for k, v in pairs(Canvas) do
    ret[k] = v
  end

  ret:init(...)

  return ret
end

-- Implemtation

function Canvas:init(ctx, lookup, width, height, buffered)
  self.ctx = ctx
  self.lookup = lookup

  if ctx.isColour then
    self.is_colour = ctx.isColour()
  else
    self.is_colour = false
  end

  self.bg = colours.black
  self.fg = colours.white

  self.x, self.y = 1, 1
  local w, h = ctx.getSize()

  self.width = width or w
  self.height = height or h

  self.buffered = buffered or false
  self.buffer = {}

  self.blinking = false

  self.offset_x = 0
  self.offset_y = 0

  self.stack = {}
end

function Canvas:push()
  self.stack[#self.stack + 1] = {
    fg = self.fg,
    bg = self.bg,

    x = self.x,
    y = self.y,

    offset_x = self.offset_x,
    offset_y = self.offset_y,
  }
end

function Canvas:pop()
  if #self.stack == 0 then
    error("Invalid state for Canvas:pop.", 2)
  end

  local state = self.stack[#self.stack]

  self.stack[#self.stack] = nil

  for k, v in pairs(state) do
    self[k] = v
  end
end

function Canvas:sub(x, y, width, height)
  return new(self:as_redirect(x, y, width, height), self.lookup, width, height)
end

function Canvas:set_fg(colour)
  if type(colour) == 'string' then
    self.fg = self.lookup(colour)
  elseif type(colour) == 'number' then
    self.fg = colour
  elseif type(colour) == 'nil' then
    self.fg = nil
  else
    error('Expected number or string, got ' .. type(colour), 2)
  end
end

function Canvas:set_bg(colour)
  if type(colour) == 'string' then
    self.bg = self.lookup(colour)
  elseif type(colour) == 'number' then
    self.bg = colour
  elseif type(colour) == 'nil' then
    self.bg = nil
  else
    error('Expected number or string, got ' .. type(colour), 2)
  end
end

function Canvas:scroll(lines)
  if self.buffered then
    local x, y = self.x, self.y
    self:move(1, self.height)

    for i=1,lines do
      table.remove(self.buffer, 1)
      self:write((" "):rep(self.width))
    end

    self:move(x, y)
  else
    self.ctx.scroll(lines)
  end
end

function Canvas:translate(x, y)
  self.offset_x = x
  self.offset_y = y
end

function Canvas:write(text)
  local x, y = self.x, self.y

  x = x + self.offset_x
  y = y + self.offset_y

  text = string.sub(text, 1) -- Convert to a string, the CC Way


  if y <= 0 or y > self.height then
    return -- No-op for off-screen.
  end

  if x > self.width then
    return
  end

  if x < 1 and math.abs(x) > #text then
    self.x = self.x + #text
    return
  end

  if x < 1 then
    local start = #text

    text = text:sub(math.abs(x))

    self.x = self.x + #text - start

    x = self.x + self.offset_x
  end

  if x + #text > self.width + 1 then
    text = text:sub(1, self.width - x)
  end

  if text == "" then
    return
  end

  if self.buffered then
    repeat table.insert(self.buffer, {}) until #self.buffer > y

    local line = self.buffer[y]

    for c_x=#text-1,0,-1 do
      local clobber = line[x + c_x]

      if clobber then
        clobber.text = clobber.text:sub(#text - c_x + 1)

        line[x + #text] = clobber

        break
      end
    end

    if #text > 1 then
      for c_x=0,#text-1 do
        line[x + c_x] = nil
      end
    end

    line[x] = {
      fg = self.fg,
      bg = self.bg,
      text = text,
    }

    self.x = x + #text

    self.buffer[y] = line
  else
    if self.bg then
      self.ctx.setBackgroundColour(self.bg)
    end

    if self.fg then
      self.ctx.setTextColour(self.fg)
    end

    self.ctx.setCursorPos(x, y)
    self.ctx.write(text)
    self.x = self.x + #text
  end
end

function Canvas:blit(x, y, width, height, ctx)
  if not self.buffered then
    error('Canvas is not a buffered canvas.', 2)
  end

  local height = height or self.height
  local width = width or self.width
  local ctx = ctx or self.ctx

  local fg = nil
  local bg = nil

  for i=1,height do
    local line = self.buffer[i + self.offset_y]

    if line then
      for j=1,width do
        local c = line[j + self.offset_x]

      	if c then
      	  if c.fg and c.fg ~= fg then
      	    fg = c.fg

      	    ctx.setTextColour(fg)
      	  end

      	  if c.bg and c.bg ~= bg then
      	    bg = c.bg
      	    ctx.setBackgroundColour(bg)
      	  end


      	  ctx.setCursorPos(j, i)
      	  ctx.write(c.text)
      	end
      end
    end
  end

  ctx.setCursorPos(self.x, self.y)
  ctx.setCursorBlink(self.blinking)
end


function Canvas:clear()
  if self.buffered then
    self.buffer = {}
  end

  for y=1,self.height do
    self:move(1, y)

    self:write((" "):rep(self.width))
  end
end

function Canvas:move(x, y)
  self.x = math.floor(tonumber(x))
  self.y = math.floor(tonumber(y))

  if not self.buffered then
    self.ctx.setCursorPos(self.x, self.y)
  end
end

function Canvas:set_cursor(x, y, visible)
  self:move(x, y)

  self.blinking = visible

  if not self.buffered then
    self.ctx.setCursorBlink(visible)
  end
end

function Canvas:as_redirect(x, y, width, height)
  local redir = {
    x = x or 1,
    y = y or 1
  }

  redir.width = width or (self.width - redir.x + 1)
  redir.height = height or (self.height - redir.y + 1)

  redir.setTextColour = function(clr)
    self:set_fg(clr)
  end

  redir.setBackgroundColour = function(clr)
    self:set_bg(clr)
  end

  redir.isColour = function()
    return self.is_colour
  end

  redir.write = function(text)
    self:write(text)
  end

  redir.getSize = function()
    return redir.width, redir.height
  end

  redir.setCursorPos = function(rel_x, rel_y)
    if rel_x > redir.width or rel_y > redir.height then
      return -- The Base Lib doesn't error here, why should we?
    end
    self:move(redir.x + rel_x - 1, redir.y + rel_y - 1)
  end

  redir.getCursorPos = function()
    return self.x - redir.x + 1, self.y - redir.y + 1
  end

  redir.setCursorBlink = function(blink)
    self:set_cursor(self.x, self.y, blink)
  end

  redir.scroll = function(lines)
    self:scroll(lines)
  end

  redir.clearLine = function()
    self:push()

    self:move(redir.x, self.y)
    self:write(string.rep(" ", redir.width))

    self:pop()
  end

  redir.clear = function()
    self:push()

    for line=redir.y,redir.y+redir.height do
      self:move(redir.x, line)
      self:write(string.rep(" ", redir.width))
    end

    self:pop()
  end

  -- Bloody Americans.
  redir.setTextColor = redir.setTextColour
  redir.setBackgroundColor = redir.setBackgroundColour
  redir.isColor = redir.isColour

  return redir
end
