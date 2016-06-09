@rules =
  conways_game_of_life: (x, y, grid) ->
      self    = grid.is_on(x: x, y: y)
      northwest = grid.is_on(x: x - 1,  y: y - 1)
      north     = grid.is_on(x: x,      y: y - 1)
      northeast = grid.is_on(x: x + 1,  y: y - 1)

      west      = grid.is_on(x: x - 1,  y: y)
      east      = grid.is_on(x: x + 1,  y: y)

      southwest = grid.is_on(x: x - 1,  y: y + 1)
      south     = grid.is_on(x: x,      y: y + 1)
      southeast = grid.is_on(x: x + 1,  y: y + 1)

      number_of_live_neighbors = _.compact([northwest, north, northeast, west, east, southwest, south, southeast]).length

      switch
        when number_of_live_neighbors == 3 then true
        when number_of_live_neighbors < 2 then false
        when number_of_live_neighbors > 3 then false
        else self

$ =>
  grid_container = jQuery('<div/>', id: 'grid_container')
  jQuery('body').prepend(grid_container)

  window.grid = new Grid(grid_container, height: 30, width: 30, interactive: true)

  automaton = new Automaton(window.grid, @rules.conways_game_of_life, 100)

  jQuery('#start').click  -> automaton.start()
  jQuery('#stop').click   -> automaton.stop()
  jQuery('#step').click   -> automaton.step()
  jQuery('#clear').click  -> automaton.clear()

