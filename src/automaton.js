// Generated by CoffeeScript 1.10.0
(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Automaton = (function() {
    function Automaton(grid, rule, step_time) {
      this.grid = grid;
      this.rule = rule;
      this.step_time = step_time;
      this.step = bind(this.step, this);
      this.height = this.grid.height;
      this.width = this.grid.width;
    }

    Automaton.prototype.step = function() {
      return _.each(this._step_instructions(), (function(_this) {
        return function(row, row_number) {
          return _.each(row, function(value, cell_number) {
            return _this.grid.set({
              x: cell_number,
              y: row_number
            }, value);
          });
        };
      })(this));
    };

    Automaton.prototype.start = function() {
      return this.interval_id = setInterval(this.step, this.step_time);
    };

    Automaton.prototype.stop = function() {
      return clearInterval(this.interval_id);
    };

    Automaton.prototype._step_instructions = function() {
      var i, ref, results;
      return _.map((function() {
        results = [];
        for (var i = 0, ref = this.height; 0 <= ref ? i < ref : i > ref; 0 <= ref ? i++ : i--){ results.push(i); }
        return results;
      }).apply(this), (function(_this) {
        return function(row_number) {
          var j, ref1, results1;
          return _.map((function() {
            results1 = [];
            for (var j = 0, ref1 = _this.width; 0 <= ref1 ? j < ref1 : j > ref1; 0 <= ref1 ? j++ : j--){ results1.push(j); }
            return results1;
          }).apply(this), function(cell_number) {
            return _this.rule(cell_number, row_number, _this.grid);
          });
        };
      })(this));
    };

    return Automaton;

  })();

}).call(this);
