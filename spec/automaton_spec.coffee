describe 'Automaton', ->

  beforeEach ->
    @grid_container = jQuery('<div/>')
    @grid = new Grid(@grid_container, height: 2, width: 2)

  it 'accepts a grid and a rule and applies the rule to the grid', ->
    rule = (x, y, grid) -> x == y

    automaton = new Automaton(@grid, rule)

    spyOn(@grid, 'set')

    automaton.step()

    expect(@grid.set).toHaveBeenCalledWith(x: 0, y: 0, 1)
    expect(@grid.set).toHaveBeenCalledWith(x: 1, y: 1, 1)

    expect(@grid.set).toHaveBeenCalledWith(x: 0, y: 1, 0)
    expect(@grid.set).toHaveBeenCalledWith(x: 1, y: 0, 0)

  it 'makes all moves simultaneously', ->
    rule = (x, y, grid) ->
      return true if x == y == 0
      return false if y > 0
      return true unless grid.state(x: x - 1, y: y)

    automaton = new Automaton(@grid, rule)

    spyOn(@grid, 'set').and.callThrough()

    automaton.step()

    expect(@grid.set).toHaveBeenCalledWith(x: 0, y: 0, 1)
    expect(@grid.set).toHaveBeenCalledWith(x: 1, y: 0, 1)

  it 'can make moves at regular intervals', ->
    jasmine.clock().install()

    rule = (x, y, grid) -> !grid.state(x: x, y: y)

    automaton = new Automaton(@grid, rule, 1000)

    spyOn(@grid, 'set').and.callThrough()

    automaton.start()

    jasmine.clock().tick(1000)

    expect(@grid.set).toHaveBeenCalledWith(x: 0, y: 0, 1)
    expect(@grid.set).toHaveBeenCalledWith(x: 1, y: 0, 1)
    expect(@grid.set).toHaveBeenCalledWith(x: 0, y: 1, 1)
    expect(@grid.set).toHaveBeenCalledWith(x: 1, y: 1, 1)

    expect(@grid.set.calls.count()).toEqual(4)

    jasmine.clock().tick(1000)

    expect(@grid.set).toHaveBeenCalledWith(x: 0, y: 0, 0)
    expect(@grid.set).toHaveBeenCalledWith(x: 1, y: 0, 0)
    expect(@grid.set).toHaveBeenCalledWith(x: 0, y: 1, 0)
    expect(@grid.set).toHaveBeenCalledWith(x: 1, y: 1, 0)

    jasmine.clock().uninstall()

  it 'can stop once started', ->
    jasmine.clock().install()

    rule = (x, y, grid) -> true

    automaton = new Automaton(@grid, rule, 1000)

    spyOn(@grid, 'set').and.callThrough()

    automaton.start()

    jasmine.clock().tick(1000)

    expect(@grid.set.calls.count()).toEqual(4)

    jasmine.clock().tick(1000)

    expect(@grid.set.calls.count()).toEqual(8)

    automaton.stop()
    jasmine.clock().tick(1000)

    expect(@grid.set.calls.count()).toEqual(8)

    jasmine.clock().uninstall()

  it 'can clear the grid', ->
    rule = (x, y, grid) -> true

    automaton = new Automaton(@grid, rule, 1000)

    automaton.step()

    automaton.clear()

    expect(@grid_container.find('[data-state="1"]').length).toEqual(0)
