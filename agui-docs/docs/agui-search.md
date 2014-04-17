agui-search
-----------

This is a simple query-and\-results compound widget.

  * **Constructor**
    * new('agui-search', width, height)
  * **Methods**
  	* None
  * **Fields**
    * results -- The results list.
    * input_box -- The input widget.
  * **Events**
    * _gui.search.input_ -- Fired when the input changes. This also clears the results box.
    * _gui.search.selected_ -- Fired when a result is selected with the enter key.