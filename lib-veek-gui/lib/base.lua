-- lint-mode: api

-- Dependencies!
os.loadAPI("__LIB__/kidven/kidven")
os.loadAPI("__LIB__/event")
os.loadAPI("__LIB__/thread")
os.loadAPI("__LIB__/canvas")

-- Load the base objects.

for _, file in ipairs(fs.list("__LIB__/veek/gui/objects")) do
	kidven.load("Object", "veek-" .. file, "__LIB__/veek/gui/objects/" .. file)
end

for _, file in ipairs(fs.list("__LIB__/veek/gui/widgets")) do
	kidven.load("Widget", 'veek-' .. file, "__LIB__/veek/gui/widgets/" .. file)
end
