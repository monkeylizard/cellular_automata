$ ->
  grid_container = jQuery('<div/>', id: 'grid_container')
  jQuery('body').append(grid_container)

  window.grid = new Grid(grid_container, height: 20, width: 20, interactive: true)

  rule = (x, y, grid) ->
    return true if x == y == 0
    grid.is_on(x: x - 1, y: y - 1)

  automaton = new Automaton(window.grid, rule, 1000)

  jQuery('#start').click -> automaton.start()
  jQuery('#stop').click -> automaton.stop()

