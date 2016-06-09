// Generated by CoffeeScript 1.10.0
(function() {
  $(function() {
    var automaton, grid_container, rule;
    grid_container = jQuery('<div/>', {
      id: 'grid_container'
    });
    jQuery('body').prepend(grid_container);
    window.grid = new Grid(grid_container, {
      height: 30,
      width: 30,
      interactive: true
    });
    rule = function(x, y, grid) {
      if ((x === y && y === 0)) {
        return true;
      }
      return grid.is_on({
        x: x - 1,
        y: y - 1
      });
    };
    automaton = new Automaton(window.grid, rule, 500);
    jQuery('#start').click(function() {
      return automaton.start();
    });
    jQuery('#stop').click(function() {
      return automaton.stop();
    });
    return jQuery('#clear').click(function() {
      return automaton.clear();
    });
  });

}).call(this);
