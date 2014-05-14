_agui-menu_
------------

_agui-menu_ is a menu widget for agui-based apps. It operates by getting passed an agui-container on creation. It can also be given an agui-app instance, or an agui\-app-window instance.

  * **Methods**
    * :add(label, callback) -- Adds an option with the given label and callback function.
    * :add_seperator() -- Adds a seperator
    * :clear() -- Clears the menu.
    * :show(x, y) -- Shows the given menu in the given place.
    * :hide() -- Hides the menu
  * **Events**
    * *None*