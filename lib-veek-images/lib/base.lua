--- Image Loading Library for veek.
-- This loads images from files and strings, and has a common representation
-- format for the images in it's code, in the form of the `veek-image` class.
-- @module veek-images

-- lint-mode: veek-api

local formats = {}

kidven.load("Object", "veek-image", "__LIB__/veek/images/image")
kidven.load("Widget", "veek-image-display", "__LIB__/veek/images/display")

for _, file in ipairs(fs.list("__LIB__/veek/images/formats/")) do
  local f = loadfile("__LIB__/veek/images/formats/" .. file)

  if f then
    formats[file] = f()
  end
end

--- Load the given image.
-- @string path The path to the image.
-- @tparam ?|string format The format of the image.
-- @treturn nil|veek-image the loaded image, or nil on failure.
function load(path, format)
  local f = fs.open(path, "r")
  if not f then
    return nil
  end

  local data = f.readAll()
  f.close()

  return load_string(data, format)
end

--- Load the given image from the given string.
-- @string str The image's data in string format.
-- @tparam ?|string format The format of the image.
-- @treturn nil|veek-image the loaded image, or nil on failure.
function load_string(str, format)
  if not format then
    for typ, cb in pairs(formats) do
      if cb.is_a(str) then
        format = typ
        break
      end
    end
  end

  if not formats[format] then
    return nil
  end

  return kidven.new('veek-image', formats[format].decode(str))
end

function save(path, format)
  if not formats[format] then
    error("Invalid Format " .. format, 2)
  end

  formats[format].encode(path, format)
end

--- Gets a list of loaded and supported image formats.
-- @treturn table Table of supported formats.
function get_formats()
  return formats
end