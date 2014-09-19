-- lint-mode: api

os.loadAPI("__LIB__/kidven/kidven")

function load_api(path)
  if fs.exists(path) then
    if fs.isDir(path) then
      if fs.exists(fs.join(path, "_load")) then
        path = fs.join(path, "_load")
      end
    end

    return dofile(path)
  end
end

for _, file in ipairs(fs.list("__LIB__/veek/_base/")) do
  kidven.load("Object", 'veek-' .. file, '__LIB__/veek/_base/' .. file)
end
