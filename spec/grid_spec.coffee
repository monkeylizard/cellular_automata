describe 'Grid', ->
  
  beforeEach ->
    @grid_container = jQuery('<div/>')

  it 'creates a grid in the given container', ->
    grid = new Grid(@grid_container, height: 10, width: 10)

    grid_table = @grid_container.children('table')
    expect(grid_table.length).toEqual(1)
    expect(grid_table.children('tr').length).toEqual(10)

    _.each grid_table.children('tr'), (row) ->
      expect(jQuery(row).children('td').length).toEqual(10)

  it 'labels each cell in the grid', ->
    grid = new Grid(@grid_container, height: 10, width: 10)

    grid_table = @grid_container.children('table')

    _.times 10, (row_number) ->
      _.times 10, (cell_number) ->
        cell = grid_table.find(".row#{row_number}#cell#{cell_number}")
        expect(cell.length).toEqual(1)
        expect(cell.data('coordinates')).toEqual(x: cell_number, y: row_number)
        expect(cell.attr('data-state')).toEqual('0')

  it 'can turn on a given cell', ->
    grid = new Grid(@grid_container, height: 10, width: 10)

    grid_table = @grid_container.children('table')

    grid.turn_on(x: 7, y: 3)

    cell = grid_table.find('.row3#cell7')
    expect(cell.attr('data-state')).toEqual('1')

  it 'can turn off a given cell', ->
    grid = new Grid(@grid_container, height: 10, width: 10)

    grid_table = @grid_container.children('table')

    grid.turn_on(x: 7, y: 3)
    grid.turn_off(x: 7, y: 3)

    expect(grid_table.find('.row3#cell7').attr('data-state')).toEqual('0')

  it 'can toggle a given cell', ->
    grid = new Grid(@grid_container, height: 10, width: 10)

    grid_table = @grid_container.children('table')

    grid.toggle(x: 4, y: 8)

    expect(grid_table.find('.row8#cell4').attr('data-state')).toEqual('1')

    grid.toggle(x: 4, y: 8)

    expect(grid_table.find('.row8#cell4').attr('data-state')).toEqual('0')

  it 'can set a given cell value', ->
    grid = new Grid(@grid_container, height: 10, width: 10)

    grid_table = @grid_container.children('table')

    grid.set(x: 4, y: 8, 1)

    expect(grid_table.find('.row8#cell4').attr('data-state')).toEqual('1')

    grid.set(x: 4, y: 8, 0)

    expect(grid_table.find('.row8#cell4').attr('data-state')).toEqual('0')

  it 'can be made interactive', ->
    grid = new Grid(@grid_container, height: 10, width: 10, interactive: true)

    grid_table = @grid_container.children('table')

    cell = grid_table.find('.row9#cell2')

    cell.click()

    expect(cell.attr('data-state')).toEqual('1')

    cell.click()

    expect(cell.attr('data-state')).toEqual('0')

  it 'can tell if a given cell is active', ->
    grid = new Grid(@grid_container, height: 10, width: 10, interactive: true)

    grid_table = @grid_container.children('table')

    grid.turn_on(x: 4, y: 5)

    expect(grid.is_on(x: 4, y: 5)).toEqual(true)

    grid.turn_off(x: 4, y: 5)

    expect(grid.is_on(x: 4, y: 5)).toEqual(false)

  it 'can read the state of a given cell', ->
    grid = new Grid(@grid_container, height: 10, width: 10, interactive: true)

    grid_table = @grid_container.children('table')

    grid.set(x: 4, y: 5, 1)

    expect(grid.state(x: 4, y: 5)).toEqual(1)

    grid.set(x: 4, y: 5, 0)

    expect(grid.state(x: 4, y: 5)).toEqual(0)

  it 'can be initialized with a number of possible states and cycle through them', ->
    grid = new Grid(@grid_container, height: 10, width: 10, states: 3)

    grid_table = @grid_container.children('table')

    coordinates = x: 2, y: 7

    expect(grid.state(coordinates)).toEqual(0)

    grid.toggle(coordinates)

    expect(grid.state(coordinates)).toEqual(1)

    grid.toggle(coordinates)

    expect(grid.state(coordinates)).toEqual(2)

    grid.toggle(coordinates)

    expect(grid.state(coordinates)).toEqual(0)
