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

  it 'can make moves at regular intervals', ->
    jasmine.clock().install()

    rule = (x, y, grid) -> !grid.is_on(x: x, y: y)

    automaton = new Automaton(@grid, rule, 1000)

    spyOn(@grid, 'turn_on').and.callThrough()
    spyOn(@grid, 'turn_off').and.callThrough()

    automaton.start()

    jasmine.clock().tick(1000)

    expect(@grid.turn_on).toHaveBeenCalledWith(x: 0, y: 0)
    expect(@grid.turn_on).toHaveBeenCalledWith(x: 1, y: 0)
    expect(@grid.turn_on).toHaveBeenCalledWith(x: 0, y: 1)
    expect(@grid.turn_on).toHaveBeenCalledWith(x: 1, y: 1)

    expect(@grid.turn_off).not.toHaveBeenCalled()

    jasmine.clock().tick(1000)

    expect(@grid.turn_off).toHaveBeenCalledWith(x: 0, y: 0)
    expect(@grid.turn_off).toHaveBeenCalledWith(x: 1, y: 0)
    expect(@grid.turn_off).toHaveBeenCalledWith(x: 0, y: 1)
    expect(@grid.turn_off).toHaveBeenCalledWith(x: 1, y: 1)

    jasmine.clock().uninstall()

  it 'can stop once started', ->
    jasmine.clock().install()

    rule = (x, y, grid) -> true

    automaton = new Automaton(@grid, rule, 1000)

    spyOn(@grid, 'turn_on').and.callThrough()

    automaton.start()

    jasmine.clock().tick(1000)

    expect(@grid.turn_on.calls.count()).toEqual(4)

    jasmine.clock().tick(1000)

    expect(@grid.turn_on.calls.count()).toEqual(8)

    automaton.stop()
    jasmine.clock().tick(1000)

    expect(@grid.turn_on.calls.count()).toEqual(8)
