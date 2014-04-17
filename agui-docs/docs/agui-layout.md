agui-layout Object
------------------

The _agui-layout_ object is an anchor-based layout engine for _lib-agui_. You can use this to  make your containers resize and move their contents when they are resized.


  * **Constructor**
    * new('agui-layout', container) -- The container we are to wrap.
  * **Methods**
    * :resize(width, height) -- Resizes the container then re-flows the content.
    * :reflow() -- Reflows the content.
    * :add_anchor(widget, side, other_side, other, dist) -- See below for details.
    * :add(widget) -- Adds a widget to the container **THIS MUST BE USED INSTEAD OF container:add()**
    * :remove(widget) -- Removes a widget from the container **THIS MUST BE USED INSTEEAD OF container:remove()**


Anchors?
--------

Anchors are made up of 5 components, all passed to add_anchor().

  * widget -- The widget the anchor is attached to.
  * side -- The side of the widget the anchor acts on.
  * other_side -- The side of the other object it acts on
  * other -- The other widget to act on, or -1 for the parent container.
  * dist -- The distance to work on.


Sides?
------

Sides can be one of: top, bottom, left, right -- and for other_side, you have the additional benifit of a middle option. That middle option will make the widget get aligned with the middle of the other widget, or to get aligned with the middle of the parent container.

_right_ and _bottom_ affect the widget's size, _top_ and _left_ affect the widget's position.