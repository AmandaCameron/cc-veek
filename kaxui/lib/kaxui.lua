-- TODO: Safety net.

os.loadAPI("__LIB__/agui/agui")

for _, name in ipairs(fs.list("__LIB__/kaxui/widgets")) do
  kidven.load("Widget", 'kaxui-' .. name, "__LIB__/kaxui/widgets/" .. name)
end