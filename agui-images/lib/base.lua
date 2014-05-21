-- Base Image Loader for agui-images

os.loadAPI("__LIB__/kidven/kidven")

local formats = {}

kidven.load("Image", "agi-image", "__LIB__/agui-images/agi-image")
kidven.load("Widget", "agi-display", "__LIB__/agui-images/agi-display")

for _, file in ipairs(fs.list("__LIB__/agui-images/formats/")) do
  local f = loadfile("__LIB__/agui-images/formats/" .. file)

  if f then
    formats[file] = f()
  end
end

function load(path, format)
  local f = fs.open(path, "r")
  if not f then
    return nil
  end

  local data = f.readAll()
  f.close()

  return load_string(data, format)
end

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

  return kidven.new('agi-image', formats[format].decode(str))
end

function save(path, format)
  if not formats[format] then
    error("Invalid Format " .. format, 2)
  end

  formats[format].encode(path, format)
end

function get_formats()
  return formats
end