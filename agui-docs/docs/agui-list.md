agui-list
---------

_agui-list_ is a simple thing that is meant to hold _agui\-list-item_ instances, as well as their sub-classes.

  * **Constructor**
    * new('agui-list', x, y, width, height)
  * **Methods**
    * :add(item, [pos]) -- Adds the given list item.
    * :clear() -- Clears the list's contents.
    * :remove(index) -- Removes the given index.
  * **Events**
    * _gui.list.changed_ current_index, current_item -- Fired when the list's selection changes.