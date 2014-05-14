agui-progress-bar
=================

_agui-progress-bar_ is a progress bar widget now built into lib-agui. It was previously housed in kaxui, but has been moved out for more general-purpose useage.

  * **Constructors**
  	* new('agui-progress-bar', x, y, width) -- Creates a new progress bar at the given x, y and width.
  * **Methods**
  	* :set_format(fmt) -- Sets the format for the progress text. %d will be replaced with the 0-100 percentage value.
  	* :set_progress(prog) -- Sets the current progress. Must be between 0 and 1, for 0 to 100%.
  	* :set_indetermenate(ind) -- Sets if the progress is currently indetermenate.
  * **Fields**
  	* No Public Fields.