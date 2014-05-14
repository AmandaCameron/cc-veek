agui-conteiner
--------------

_agui-container_ is the base class for containers, that contain other _agui-widget_ instances.

  * **Constructor**
    * new('agui-container', x, y, width, height)
  * **Methods**
    * :add(widget) -- Adds the given _agui-widget_ instance to this container.
    * :remove(widget) -- Removes the given _agui-widget_ instance from this container.
    * :select(widget) -- Selects the given _agui-widget_ instance.
    * :get_focused() -- Returns the given focused _agui_widget_ instance, or nil if nothing is selected.
  * **Fields**
    * No Public fields.