describe 'Grid', ->

  it 'creates a grid in the given container', ->
    grid_container = jQuery('<div/>')
    grid = new Grid(grid_container, height: 10, width: 10)

    grid_table = grid_container.children('table')
    expect(grid_table.length).toEqual(1)
    expect(grid_table.children('tr').length).toEqual(10)

    _.each grid_table.children('tr'), (row) ->
      expect(jQuery(row).children('td').length).toEqual(10)

  it 'labels each cell in the grid', ->
    grid_container = jQuery('<div/>')
    grid = new Grid(grid_container, height: 10, width: 10)

    grid_table = grid_container.children('table')

    _.times 10, (row_number) ->
      _.times 10, (cell_number) ->
        expect(grid_table.find(".row#{row_number}#cell#{cell_number}").length).toEqual(1)

  it 'can turn on a given cell', ->
    grid_container = jQuery('<div/>')
    grid = new Grid(grid_container, height: 10, width: 10)

    grid_table = grid_container.children('table')

    grid.turn_on(x: 7, y: 3)

    expect(grid_table.find('.row3#cell7').hasClass('active')).toEqual(true)

  it 'can turn off a given cell', ->
    grid_container = jQuery('<div/>')
    grid = new Grid(grid_container, height: 10, width: 10)

    grid_table = grid_container.children('table')

    grid.turn_on(x: 7, y: 3)
    grid.turn_off(x: 7, y: 3)

    expect(grid_table.find('.row3#cell7').hasClass('active')).toEqual(false)

  it 'can toggle a given cell', ->
    grid_container = jQuery('<div/>')
    grid = new Grid(grid_container, height: 10, width: 10)

    grid_table = grid_container.children('table')

    grid.toggle(x: 4, y: 8)

    expect(grid_table.find('.row8#cell4').hasClass('active')).toEqual(true)

    grid.toggle(x: 4, y: 8)

    expect(grid_table.find('.row8#cell4').hasClass('active')).toEqual(false)