agui-widget
-----------

_agui-widget_ is the base widget for all agui widgets, it's mostly an interface for other apps, but does provide some helper functions to help widget developers.

  * **Constructor**
    * new('agui-widget', x, y, width, height)
  * **Methods**
    * :add_flag(flag) -- Add a flag to the widget.
    * :has_flag(flag) -- Returns true if the widget has the given flag.
    * :trigger(evt, ...) -- Triggers an event in the app's GUI pump.
    * :set_enabled(enabled) -- Enable/disables the given widget.
    * :resize(width, height) -- Resizes the given widget, handling the nessary magic for this.
    * :move(x, y) -- Moves the widget to the given x and y
  * **Callbacks**
    * :focus() -- Called when the widget is focused.
    * :blur() -- Calls when the widget is un-focused.
    * :char(c) -- coorsponds to the `char` event in the main event pump, assuming your widget is focused.
    * :key(keycode) -- `key` event.
    * :clicked(x, y, btn) -- Mouse clicks.
    * :dragged(x_delta, y_delta, btn) -- Mouse drags, in delta.
    * :scroll(x, y, direction) -- Mouse scrolls.
    * :draw(canvas) -- You should do your drawing here, you're given a _lib-canvas_ canvas object.
  * **Fields**
  	* id -- The given widget's ID.
  	* x, y -- Position
  	* width, height -- Size
  	* main -- The _agui-app_ object for this app.

All other fields should be considered private, and not directly manupulated.

Events
------

The :trigger() method is used hevially in the base widgets. It also prefixes the widget's ID before the arguments it's passed, so all the events in _agui-widget_ sub-classes are expected to have an `id` paramater before them.