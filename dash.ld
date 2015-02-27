file = "Project Veek.docset/Contents/Resources/docSet.dsidx"

function interface(db, mod)
  db:exec("INSERT OR IGNORE INTO searchIndex(name, type, path) " ..
  "VALUES('" .. mod.name .. "', 'Interface', " ..
  "'classes/" .. mod.name .. ".html')")


  for _, item in ipairs(mod.items) do
    if item.type == 'function' then
      db:exec("INSERT OR IGNORE INTO searchIndex(name, type, path) " ..
      " VALUES(''" .. item.name .. "', 'Function'," ..
      " 'interfaces/" .. mod.name .. ".html#" .. item.name .. "');")
    end
  end
end

function widget(db, mod)
  db:exec("INSERT OR IGNORE INTO searchIndex(name, type, path) " ..
  "VALUES('" .. mod.name .. "', 'Class', " ..
  "'widgets/" .. mod.name .. ".html')")

  for _, item in ipairs(mod.items) do
    if item.type == 'function' then
      db:exec("INSERT OR IGNORE INTO searchIndex(name, type, path) " ..
      " VALUES(''" .. item.name .. "', 'Function'," ..
      " 'widgets/" .. mod.name .. ".html#" .. item.name .. "');")
    elseif item.type == 'event' then
      db:exec("INSERT OR IGNORE INTO searchIndex(name, type, path) " ..
      " VALUES(''" .. item.name .. "', 'Event'," ..
      " 'widgets/" .. mod.name .. ".html#" .. item.name .. "');")
    end
  end
end

function topic(db, mod)
end