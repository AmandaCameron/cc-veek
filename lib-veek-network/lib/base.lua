-- lint-mode: veek-api

-- Dependencies!
os.loadAPI("__LIB__/kidven/kidven")
os.loadAPI("__LIB__/thread")

-- Load the base objects.

for _, file in ipairs(fs.list("__LIB__/veek/network/objects")) do
	kidven.load("Object", "veek-network-" .. file, "__LIB__/veek/network/objects/" .. file)
end
