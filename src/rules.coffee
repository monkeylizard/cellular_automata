@demo_rules =
  conways_game_of_life:
    name: "Conway's Game of Life"
    states: 2
    colors: ['inherit', '#E8107C']
    rule: (x, y, grid) ->
      self      = grid.is_on(x: x, y: y)
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

  fire_propagation:
    name: 'Fire Propagation'
    states: 7
    colors: ['inherit', 'black', '#ED6509', '#ED6509', '#ED6509', '#ED6509', '#632E0A']
    rule: (x, y, grid) ->
      NORMAL      = 0
      FIREBREAK   = 1
      FIRESTART   = 2
      BURNED_OUT  = 6

      self = grid.state(x: x, y: y)

      return FIREBREAK if self == FIREBREAK
      return Math.min(self + 1, BURNED_OUT) if self > FIREBREAK

      northwest = grid.state(x: x - 1,  y: y - 1)
      north     = grid.state(x: x,      y: y - 1)
      northeast = grid.state(x: x + 1,  y: y - 1)

      west      = grid.state(x: x - 1,  y: y)
      east      = grid.state(x: x + 1,  y: y)

      southwest = grid.state(x: x - 1,  y: y + 1)
      south     = grid.state(x: x,      y: y + 1)
      southeast = grid.state(x: x + 1,  y: y + 1)
    
      neighbors = [northwest, north, northeast, west, east, southwest, south, southeast]
      number_of_burning_neighbors = _.size(_.filter(neighbors, (neighbor) -> neighbor > FIREBREAK && neighbor < BURNED_OUT))

      chance_of_catching_fire = number_of_burning_neighbors * 1 / 8

      return FIRESTART if Math.random() < chance_of_catching_fire
      self

  wire_world:
    name: 'Wire World'
    states: 4
    colors: ['inherit', 'black', 'yellow', 'orange']
    rule: (x, y, grid) ->
      BACKGROUND = 0
      WIRE = 1
      HEAD = 2
      TAIL = 3

      self = grid.state(x: x, y: y)

      return BACKGROUND if self == BACKGROUND
      return TAIL if self == HEAD
      return WIRE if self == TAIL

      northwest = grid.state(x: x - 1,  y: y - 1)
      north     = grid.state(x: x,      y: y - 1)
      northeast = grid.state(x: x + 1,  y: y - 1)

      west      = grid.state(x: x - 1,  y: y)
      east      = grid.state(x: x + 1,  y: y)

      southwest = grid.state(x: x - 1,  y: y + 1)
      south     = grid.state(x: x,      y: y + 1)
      southeast = grid.state(x: x + 1,  y: y + 1)

      neighbors = [northwest, north, northeast, west, east, southwest, south, southeast]

      number_of_active_neighbors = _.size(_.filter(neighbors, (neighbor) -> neighbor == HEAD))

      return HEAD if number_of_active_neighbors == 1 || number_of_active_neighbors == 2

      WIRE

  rule_110:
    name: 'Rule 110'
    states: 2
    colors: ['inherit', '#E8107C']
    rule: (x, y, grid) ->
      self = grid.state(x: x, y: y)
      return 1 if self

      northwest = grid.state(x: x - 1,  y: y - 1)
      north     = grid.state(x: x,      y: y - 1)
      northeast = grid.state(x: x + 1,  y: y - 1)

      outcomes = [0,1,1,1,0,1,1,0]

      value = parseInt([northwest, north, northeast].join(''), 2)
      outcomes[value] || 0
