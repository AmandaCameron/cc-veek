-- TODO: Safety net.

os.loadAPI("__LIB__/veek/veek")
veek.load_api("__LIB__/veek/gui")

for _, name in ipairs(fs.list("__LIB__/kaxui/widgets")) do
  kidven.load("Widget", 'kaxui-' .. name, "__LIB__/kaxui/widgets/" .. name)
end
