file = "Project Veek.docset/Contents/Resources/docSet.dsidx"

function classmod.event(db, mod, item)
  db:exec("INSERT OR IGNORE INTO searchIndex(name, type, path) " ..
  " VALUES(''" .. item.name .. "', 'Event'," ..
  " 'classes/" .. mod.name .. ".html#" .. item.name .. "');")
end
