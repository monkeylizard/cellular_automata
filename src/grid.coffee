class @Grid

  constructor: (@container, { height: @height, width: @width }) ->
    @_add_grid_to_container()

  turn_on: (coordinates) ->
    @_grid_cell(coordinates).addClass('active')

  turn_off: (coordinates) ->
    @_grid_cell(coordinates).removeClass('active')

  toggle: (coordinates) ->
    @_grid_cell(coordinates).toggleClass('active')

  _grid_cell: ({ x: x, y: y }) -> @grid.find(".row#{y}#cell#{x}")

  _add_grid_to_container: ->
    @container.append(@_grid())

  _grid: ->
    @grid = jQuery('<table/>')
    _.times @height, (row_number) => @grid.append(@_row(row_number))
    @grid

  _row: (row_number) ->
    row = jQuery('<tr/>')
    _.times @width, (cell_number) => row.append @_cell(row_number, cell_number)

  _cell: (row_number, cell_number) -> jQuery('<td/>', class: "row#{row_number}", id: "cell#{cell_number}")
