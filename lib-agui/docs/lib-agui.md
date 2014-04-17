_lib-agui_ is a "GUI" toolkit for computercraft. It is backed by my _lib-kidven_ for objects and _lib-canvas_ for buffers to draw the elements under. The app itself is housed under an **agui-app** agui-object, which handles the event pump and the thread pool for your app. Every app should have a :main() call in it to kick off the thread pool and event pump.

The event pump is hooked into by using the :subscribe() call on the agui-app object, it also allows you to fire events with :trigger() These functions are actually provided by _lib-event_ and as such are available to any event-pool sub-class.

Basic Widgets
=============
  * agui-widget -- Basic widget, every GUI widget descends from this at some point along the heigharchy.
  * agui-container -- Basic container widget, handles storage of other widgets and drawing of them.

Input Widgets
=============

  * agui-button -- Clickable button, fires an 'gui.button.pressed' event when it's triggered.
  * agui-checkbox -- Toggle box with a label. Fires a 'gui.input.changed' event when toggled.
  * agui-input -- Text input box, fires a 'gui.input.changed' event when text inside it changes.
  * agui-list -- Displays a list _list-item_ widgets, fires a 'gui.list.changes' event when the selection is changed.

Display Widgets
===============
  
  * agui-split-pane -- Shows a common side-bar pattern for two widgets.
  * agui-tab-bar -- Shows a tab bar that allows you to change tabs, each tab can contain a single widget.
  * agui-window -- A window that is bound inside the app's display canvas
  * agui-virt-seperator -- A Vertical seperator.
  * agui-horiz-seperator -- A horizontal seperator.
  * agui-textbox -- Multi-line auto-wrapping textbox widget, showing plaintext stuff.
  * agui-label -- Shows a single-line bit of text, ellipsising it if nessary.
  * agui-search -- A search bar widget, a combonation of a agui-input and an agui-list
  * agui-progress-bar -- Progress bar! Takes a 0-1 number and shows a percentage!

Notes for Users
===============
  * In version 9 of lib-agui everything was changed to use a agui- prefix. As a result, old programs will break.