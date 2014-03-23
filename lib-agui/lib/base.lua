-- Dependencies!
os.loadAPI("__LIB__/kidven/kidven")
os.loadAPI("__LIB__/event")
os.loadAPI("__LIB__/thread")
os.loadAPI("__LIB__/canvas")

-- Load the base objects.

for _, file in ipairs(fs.list("__LIB__/agui/objects")) do
	kidven.load("Object", file, "__LIB__/agui/objects/" .. file)
end

for _, file in ipairs(fs.list("__LIB__/agui/widgets")) do
	kidven.load("Widget", 'agui-' .. file, "__LIB__/agui/widgets/" .. file)
end