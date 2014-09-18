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

kidven.load("Object", "__LIB__/veek/_base/objects/string", "veek-string")
