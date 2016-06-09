class @Automaton

  constructor: (@grid, @rule) ->
    @height = @grid.height
    @width  = @grid.width

  step: ->
    _.each @_step_instructions(), (row, row_number) =>
      _.each row, (value, cell_number) =>
        if value then @grid.turn_on(x: cell_number, y: row_number) else @grid.turn_off(x: cell_number, y: row_number)

  _step_instructions: ->
    _.map [0...@height], (row_number) =>
      _.map [0...@width], (cell_number) =>
        @rule(cell_number, row_number, @grid)
