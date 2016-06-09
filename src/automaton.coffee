class @Automaton

  constructor: (@grid, @rule, @step_time) ->
    @height = @grid.height
    @width  = @grid.width

  step: =>
    _.each @_step_instructions(), (row, row_number) =>
      _.each row, (value, cell_number) =>
        @grid.set(x: cell_number, y: row_number, value)

  start: -> @interval_id = setInterval(@step, @step_time)

  stop: -> clearInterval(@interval_id)

  clear: ->
    @_map_cells (row_number, cell_number) => @grid.turn_off(x: cell_number, y: row_number)

  _step_instructions: ->
    @_map_cells (row_number, cell_number) => @rule(cell_number, row_number, @grid)

  _map_cells: (iteratee) ->
    _.map [0...@height], (row_number) =>
      _.map [0...@width], (cell_number) =>
        iteratee(row_number, cell_number)
