-- lint-mode: veek-widget

--- Printer Preview widget. Takes a bunch of printer calls
-- and renders them as a widget.
-- @widget veek-printer-preview

_parent = "veek-scroll-view"

--- Initalises a veek-printer-preview object.
-- @int width The width of the display.
-- @int height The height of the display.
function Widget:init(width, height)
  self.veek_scroll_view:init(width, height)

  self.pages = {}
  self.cur_page = {}

  self.veek_widget.fg = 'black'
  self.veek_widget.bg = 'grey'

  self.veek_scroll_view.draw_contents = function(c)
    self:draw_contents(c)
  end

  self.veek_scroll_view.get_size = function()
    return self:get_size()
  end
end

--- Returns a fake peripheral.wrap-alike for printer objects.
-- Allowing you to designate the displayed page.
-- @treturn object An object implementing all the methods of a printer peripheral.
function Widget:peripheral()
  local fakeTerm = {}

  function fakeTerm.getSize()
    return 24, 21
  end

  function fakeTerm.isColour()
    return false
  end

  local ret = {}

  function ret.newPage()
    self.cur_page = {
      ["title"] = "",
      ["contents"] = canvas.new(fakeTerm, function(c) return c end, 24, 21, true)
    }

    self.cur_page.contents:set_bg(colours.white)
    self.cur_page.contents:set_fg(colours.black)

    --self.cur_page.contents:clear()

    self.cur_page.contents:move(1, 1)
  end

  function ret.endPage()
    self.pages[#self.pages + 1] = self.cur_page

    self.cur_page = {}

    self:reflow()
  end

  function ret.write(str)
    self.cur_page.contents:write(str)
  end

  function ret.getCursorPos()
    return self.cur_page.contents.x, self.cur_page.contents.y
  end

  function ret.setCursorPos(x, y)
    return self.cur_page:move(x, y)
  end

  function ret.setPageTitle(title)
    self.cur_page.title = title
  end

  function ret.getInkLevel()
    return 64
  end

  function ret.getPageSize()
    return 24, 21
  end

  function ret.getPaperLevel()
    return 384
  end

  return ret
end

function Widget:get_size()
  return self.veek_widget.width, #self.pages * 25
end

function Widget:draw_contents(c)
  c:clear()

  local x = 1

  if c.width > 24 then
    x = c.width / 2 - 12 + 1
  end

  for i, page in ipairs(self.pages) do
    local i = i - 1

    c:set_bg('lightGrey')

    c:move(x, 25 * i + 2)

    c:write(page.title)

    c:write((" "):rep(24 - (c.x - x)))

    local str = "Page " .. i + 1 .. "/" .. #self.pages

    c:move(x + 24 - #str, 25 * i + 2)
    c:write(str)

    local pc = c:as_redirect(x, (25 * i) + 3, 24, 21)

    pc.setTextColour(colours.black)
    pc.setBackgroundColour(colours.white)
    pc.clear()

    page.contents:blit(1, 1, nil, nil, pc)
  end
end
