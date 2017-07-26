describe 'CellularAutomata', ->

  beforeEach ->
    @container = jQuery('<div/>')
    @rules = 
      first_rule:
        name: 'The first rule'
        states: 2
        rule: ->
        colors: ['black', 'white']
      second_rule:
        name: 'The second rule'
        states: 3
        rule: ->
        colors: ['black', 'white', 'green']

  describe 'setting up', ->

    it 'sets up a Grid and an Automaton in the given container with appropriate defaults', ->
      grid_container = jQuery('<div/>', id: 'grid_container').appendTo(@container)
      spyOn(@container, 'find').and.returnValue(grid_container)

      rules =  first_rule: { states: 2, rule: -> }
      cellular_automata = new CellularAutomata(container: @container, rules: rules)

      grid = some: 'grid'
      spyOn(window, 'Grid').and.returnValue(grid)
      spyOn(window, 'Automaton')

      cellular_automata.start(rule: 'first_rule')

      expect(Grid).toHaveBeenCalledWith(@container, height: 30, width: 50, interactive: true, states: 2)
      expect(Automaton).toHaveBeenCalledWith(grid, rules.first_rule.rule, 100)

    it 'empties the container before starting', ->
      @container.empty()
      grid_container = jQuery('<div/>', id: 'grid_container').appendTo(@container)
      grid_container.append(jQuery('<div/>', id: 'clean_me_up'))

      rules =  first_rule: { states: 2, rule: -> }
      cellular_automata = new CellularAutomata(container: @container, rules: rules)

      cellular_automata.start(rule: 'first_rule')

      expect(@container.find('#clean_me_up').length).toEqual(0)

    it 'can specify settings for Grid and an Automaton', ->
      grid_container = jQuery('<div/>', id: 'grid_container').appendTo(@container)
      spyOn(@container, 'find').and.returnValue(grid_container)

      rules =  first_rule: { states: 2, rule: -> }
      cellular_automata = new CellularAutomata(container: @container, rules: rules, height: 10, width: 10, interactive: false, step_time: 50)

      grid = some: 'grid'
      spyOn(window, 'Grid').and.returnValue(grid)
      spyOn(window, 'Automaton')

      cellular_automata.start(rule: 'first_rule')

      expect(Grid).toHaveBeenCalledWith(@container, height: 10, width: 10, interactive: false, states: 2)
      expect(Automaton).toHaveBeenCalledWith(grid, rules.first_rule.rule, 50)

  describe 'controls', ->

    beforeEach ->
      @container = jQuery('<div/>')
      @automaton =
        start: jasmine.createSpy('start')
        stop: jasmine.createSpy('stop')
        step: jasmine.createSpy('step')
        clear: jasmine.createSpy('clear')
      spyOn(window, 'Automaton').and.returnValue(@automaton)

      rules =  first_rule: { states: 2, rule: -> }
      cellular_automata = new CellularAutomata(container: @container, rules: rules)
      cellular_automata.start(rule: 'first_rule')

    it 'creates control buttons', ->
      controls = @container.find('#controls_container')
      start = controls.find('#start')
      stop = controls.find('#stop')
      step = controls.find('#step')
      clear = controls.find('#clear')

      expect(start.length).toEqual(1)
      expect(start.text()).toEqual('Start')
      expect(stop.length).toEqual(1)
      expect(stop.text()).toEqual('Stop')
      expect(step.length).toEqual(1)
      expect(step.text()).toEqual('Step')
      expect(clear.length).toEqual(1)
      expect(clear.text()).toEqual('Clear')

    it 'creates the control buttons in an existing container, if one is given', ->
      @container.empty()

      @container.append jQuery('<div/>', id: 'controls')

      rules =  first_rule: { states: 2, rule: -> }
      cellular_automata = new CellularAutomata(container: @container, rules: rules)
      cellular_automata.start(rule: 'first_rule')

      controls = @container.find('#controls_container')
      expect(controls.length).toEqual(1)

    it 'creates a menu for rule selection', ->
      cellular_automata = new CellularAutomata(container: @container, rules: @rules)
      cellular_automata.start(rule: 'second_rule')

      controls = @container.find('#controls_container')
      menu = controls.find('select#menu')

      expect(menu.length).toEqual(1)
      options = menu.find('option')
      expect(options.length).toEqual(2)

      expect(menu.val()).toEqual('second_rule')

      expect(jQuery(options[0]).attr('value')).toEqual('first_rule')
      expect(jQuery(options[0]).text()).toEqual('The first rule')

      expect(jQuery(options[1]).attr('value')).toEqual('second_rule')

      expect(jQuery(options[1]).text()).toEqual('The second rule')

    it 'selecting a menu item starts that rule', ->
      cellular_automata = new CellularAutomata(container: @container, rules: @rules)
      cellular_automata.start(rule: 'first_rule')

      controls = @container.find('#controls_container')
      menu = controls.find('select#menu')

      spyOn(cellular_automata, 'start')

      menu.val('second_rule')
      menu.trigger('change')

      expect(cellular_automata.start).toHaveBeenCalledWith(rule: 'second_rule')

    it 'start button starts the automaton', ->
      @container.find('#controls_container #start').click()

      expect(@automaton.start).toHaveBeenCalled()

    it 'stop button stops the automaton', ->
      @container.find('#controls_container #stop').click()

      expect(@automaton.stop).toHaveBeenCalled()

    it 'step button steps the automaton', ->
      @container.find('#controls_container #step').click()

      expect(@automaton.step).toHaveBeenCalled()

    it 'clear button clears the automaton', ->
      @container.find('#controls_container #clear').click()

      expect(@automaton.clear).toHaveBeenCalled()

    describe 'disables any pre-existing handlers', ->
      beforeEach ->
        @new_automaton =
          start: jasmine.createSpy('start')
          stop: jasmine.createSpy('stop')
          step: jasmine.createSpy('step')
          clear: jasmine.createSpy('clear')
        window.Automaton.and.returnValue(@new_automaton)

        rules =  first_rule: { states: 2, rule: -> }
        cellular_automata = new CellularAutomata(container: @container, rules: rules)
        cellular_automata.start(rule: 'first_rule')

      it 'on the start button', ->
        @container.find('#controls_container #start').click()

        expect(@new_automaton.start).toHaveBeenCalled()
        expect(@automaton.start).not.toHaveBeenCalled()

      it 'on the stop button', ->
        @container.find('#controls_container #stop').click()

        expect(@new_automaton.stop).toHaveBeenCalled()
        expect(@automaton.stop).not.toHaveBeenCalled()

      it 'on the step button', ->
        @container.find('#controls_container #step').click()

        expect(@new_automaton.step).toHaveBeenCalled()
        expect(@automaton.step).not.toHaveBeenCalled()

      it 'on the clear button', ->
        @container.find('#controls_container #clear').click()

        expect(@new_automaton.clear).toHaveBeenCalled()
        expect(@automaton.clear).not.toHaveBeenCalled()

  describe 'color rules', ->

    beforeEach ->
      @rules = 
        first_rule:
          states: 2
          rule: ->
          colors: ['black', 'white']

    it 'creates css for the color rules for each state given', ->
      cellular_automata = new CellularAutomata(container: @container, rules: @rules)
      cellular_automata.start(rule: 'first_rule')

      styles = @container.find('style')
      expect(styles.length).toEqual(2)

      expect(jQuery(styles[0]).html()).toEqual("[data-state='0'] { background-color: black; }")
      expect(jQuery(styles[1]).html()).toEqual("[data-state='1'] { background-color: white; }")

    it 'removes any pre-existing color rules', ->
      @container.append jQuery('<style>.foo { background-color: black }</style>')

      cellular_automata = new CellularAutomata(container: @container, rules: @rules)
      cellular_automata.start(rule: 'first_rule')

      styles = @container.find('style')
      expect(styles.length).toEqual(2)

      expect(jQuery(styles[0]).html()).toEqual("[data-state='0'] { background-color: black; }")
      expect(jQuery(styles[1]).html()).toEqual("[data-state='1'] { background-color: white; }")
