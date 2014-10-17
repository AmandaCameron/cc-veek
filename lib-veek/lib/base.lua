-- lint-mode: api

os.loadAPI("__LIB__/kidven/kidven")

function load_api(path)
  if fs.exists(path) then
    if fs.isDir(path) then
      if fs.exists(fs.combine(path, "_load")) then
        path = fs.combine(path, "_load")
      end
    end

    return dofile(path)
  end
end

for _, file in ipairs(fs.list("__LIB__/veek/_base/interfaces/")) do
  kidven.load("Object", 'veek-' .. file, '__LIB__/veek/_base/interfaces/' .. file)
end

for _, file in ipairs(fs.list("__LIB__/veek/_base/objects/")) do
  kidven.load("Object", 'veek-' .. file, '__LIB__/veek/_base/objects/' .. file)
end

-- Types!

function string(str)
  if str.is_a and str:is_a('veek-string') then
    return str
  end

  return kidven.new('veek-string', str)
end

function attrib_string(str)
  if str.is_a and str:is_a('veek-attrib-string') then
    return str
  end

  return kidven.new('veek-attrib-string', str)
end
