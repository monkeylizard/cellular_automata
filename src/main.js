// Generated by CoffeeScript 1.10.0
(function() {
  this.rules = {
    conways_game_of_life: function(x, y, grid) {
      var east, north, northeast, northwest, number_of_live_neighbors, self, south, southeast, southwest, west;
      self = grid.is_on({
        x: x,
        y: y
      });
      northwest = grid.is_on({
        x: x - 1,
        y: y - 1
      });
      north = grid.is_on({
        x: x,
        y: y - 1
      });
      northeast = grid.is_on({
        x: x + 1,
        y: y - 1
      });
      west = grid.is_on({
        x: x - 1,
        y: y
      });
      east = grid.is_on({
        x: x + 1,
        y: y
      });
      southwest = grid.is_on({
        x: x - 1,
        y: y + 1
      });
      south = grid.is_on({
        x: x,
        y: y + 1
      });
      southeast = grid.is_on({
        x: x + 1,
        y: y + 1
      });
      number_of_live_neighbors = _.compact([northwest, north, northeast, west, east, southwest, south, southeast]).length;
      switch (false) {
        case number_of_live_neighbors !== 3:
          return true;
        case !(number_of_live_neighbors < 2):
          return false;
        case !(number_of_live_neighbors > 3):
          return false;
        default:
          return self;
      }
    }
  };

  $((function(_this) {
    return function() {
      var automaton, grid_container;
      grid_container = jQuery('<div/>', {
        id: 'grid_container'
      });
      jQuery('body').prepend(grid_container);
      window.grid = new Grid(grid_container, {
        height: 30,
        width: 30,
        interactive: true
      });
      automaton = new Automaton(window.grid, _this.rules.conways_game_of_life, 100);
      jQuery('#start').click(function() {
        return automaton.start();
      });
      jQuery('#stop').click(function() {
        return automaton.stop();
      });
      jQuery('#step').click(function() {
        return automaton.step();
      });
      return jQuery('#clear').click(function() {
        return automaton.clear();
      });
    };
  })(this));

}).call(this);
