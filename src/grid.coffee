class @Grid

  constructor: (@container, { height: @height, width: @width, interactive: interactive }) ->
    @_add_grid_to_container()
    @_add_interactivity() if interactive

  turn_on: (coordinates) ->
    @_grid_cell(coordinates).addClass('active')

  turn_off: (coordinates) ->
    @_grid_cell(coordinates).removeClass('active')

  toggle: (coordinates) ->
    @_grid_cell(coordinates).toggleClass('active')

  is_on: (coordinates) ->
    @_grid_cell(coordinates).hasClass('active')

  set: (coordinates, value) ->
    if value then @turn_on(coordinates) else @turn_off(coordinates)

  _add_interactivity: ->
    self = @
    @grid.find('td').click ->
      self.toggle(jQuery(this).data('coordinates'))

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

  _cell: (row_number, cell_number) ->
    cell = jQuery('<td/>', class: "row#{row_number}", id: "cell#{cell_number}")
    cell.data('coordinates', x: cell_number, y: row_number)
