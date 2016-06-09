describe 'Automaton', ->

  beforeEach ->
    @grid_container = jQuery('<div/>')
    @grid = new Grid(@grid_container, height: 2, width: 2)

  it 'accepts a grid and a rule and applies the rule to the grid', ->
    rule = (x, y, grid) -> x == y

    automaton = new Automaton(@grid, rule)

    spyOn(@grid, 'turn_on')
    spyOn(@grid, 'turn_off')

    automaton.step()

    expect(@grid.turn_on).toHaveBeenCalledWith(x: 0, y: 0)
    expect(@grid.turn_on).toHaveBeenCalledWith(x: 1, y: 1)

    expect(@grid.turn_off).toHaveBeenCalledWith(x: 0, y: 1)
    expect(@grid.turn_off).toHaveBeenCalledWith(x: 1, y: 0)

  it 'makes all moves simultaneously', ->
    rule = (x, y, grid) ->
      return true if x == y == 0
      return false if y > 0
      return true unless grid.is_on(x: x - 1, y: y)

    automaton = new Automaton(@grid, rule)

    spyOn(@grid, 'turn_on').and.callThrough()

    automaton.step()

    expect(@grid.turn_on).toHaveBeenCalledWith(x: 0, y: 0)
    expect(@grid.turn_on).toHaveBeenCalledWith(x: 1, y: 0)
