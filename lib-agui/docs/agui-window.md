agui-window
-----------

agui-window is a in-screen window. If you want to add a secondary window outside the main app's window in supported Shells, please see agui-app:new_window() instead.

  * **Constructor**
  	* new('agui-window', title, width, height)
  * **Methods**
    * _agui-container_ methods apply.
  * **Fields**
    * title -- The window's title.
    * flags -- The window's flags, see below for details.
  * **Events**
    * _gui.window.closed_ -- Fired when the close control is used.
    * _gui.window.minimised_ -- Fired when the minimise control is used.
    * _gui.window.maximised_ -- Fired when the maximised control is used.
    * _gui.window.resized_ -- Called when the window is resized.

Flags
-----

The _flags_ field is a table that contains some of the following attributes:

  * closable -- Should be true/present if the window should have a close control
  * minimisable -- Should be true/present if the window should have a minimise control.
  * maximisable -- Should be present if the window is maximisable ( Requires: resizable )
  * resizable -- Should be present if the window is resizable
