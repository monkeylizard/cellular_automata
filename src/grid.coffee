class @Grid

  constructor: (container, { height: @height, width: @width, interactive: interactive, states: @states }) ->
    @container = @_grid_container_in(container)
    @states ||= 2
    @_add_grid_to_container()
    @_add_interactivity() if interactive

  turn_on: (coordinates) -> @set(coordinates, 1)

  turn_off: (coordinates) -> @set(coordinates, 0)

  toggle: (coordinates) ->
    @set(coordinates, (@state(coordinates) + 1) % @states)

  state: (coordinates) ->
    Number(@_grid_cell(coordinates).attr('data-state'))

  set: (coordinates, value) ->
    @_grid_cell(coordinates).attr('data-state', value)

  _grid_container_in: (container) ->
    @_existing_grid_container_in(container) || @_new_grid_container_in(container)

  _new_grid_container_in: (container) ->
    jQuery('<div/>', id: 'grid_container').appendTo(container)

  _existing_grid_container_in: (container) ->
    grid_container = container.find('#grid_container')
    return unless grid_container.length > 0
    grid_container

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
    cell = jQuery('<td/>', class: "row#{row_number}", id: "cell#{cell_number}", 'data-state': 0)
    cell.data('coordinates', x: cell_number, y: row_number)
