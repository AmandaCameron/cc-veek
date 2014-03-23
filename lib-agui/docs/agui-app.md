agui-app Object.
----------------

The _agui-app_ object is the central event pump and method of interaction for an agui app. It also handles the drawing of the GUI widgets, from the top-level object.

  * **Methods**
    * :add(widget) -- Adds widget to the top-level GUI of the main window.
    * :remove(widget) -- Rmeoves the given widget from the top-level GUI of the main window.
    * :select(widget) -- Selects the given child widget of the top-level.
    * :new_window(title, width, height) -- Creates a window, as per the term.newWindow() api, falling back to an agui-window object in the top-level
    * :active_window() -- Returns the active window.
    * :load_theme(file) -- Loads the given AGUI theme file.
    * :main() -- This fires off the event pump. You are expected to call this to start your app.
    * :quit() -- Kills the event pump, closing your app.
  * **Fields**
    * main\_window -- The main _agui-app-window_ object, representing the main window for the screen.
    * pool -- The Thread Pool that agui maintains. see _lib-thread_ for docs on this object.
  * **Events**
    * _window.resize_ window_id -- Called when a window is resized, can be the main window or a child window, the window_id paramater will tell you.

Examples?
---------

For examples on using this, please look in the _agui-demos_ package.