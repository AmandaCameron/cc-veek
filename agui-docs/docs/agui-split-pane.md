_agui-split-pane_
-----------------

_agui-split-pane_ is an AGUI widget that splits the screen into two, unevenly sided parts. The left part is smaller than the right. The Left part is for 
the side-bar actions. if you are on a pocket computer, the side-bar will be hidden completely, but can be revieled by dragging from the left-most character
on the screen. This allows you to have maximum screen realestate.

  * **Constructors**
  	* new('agui-split-pane', side_bar, main_view) -- Constructs a new agui-split-pane object with the given side-bar and main views.
  * **Methods**
  	* :resize(w, h) -- Resizes the widget, as per agui-widget.
  * **Properties**
  	* .min_pos -- The minimum size the side-bar can be. If it's 0.
  	* .max_pos -- The maximum size the side-bar can be.
  	* .position -- The current size of the side-bar