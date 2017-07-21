class @CellularAutomata
  DEFAULT_HEIGHT = 30
  DEFAULT_WIDTH = 50
  DEFAULT_STEP_TIME = 100

  constructor: ({ container: @container, rules: @rules, height: @height, width: @width, interactive: @interactive, step_time: @step_time }) ->
    @height ||= DEFAULT_HEIGHT
    @width ||= DEFAULT_WIDTH
    @step_time ||= DEFAULT_STEP_TIME
    @interactive = true unless @interactive?

  start: ({ rule: rule }) ->
    grid = new Grid(@_grid_container(), height: @height, width: @width, interactive: @interactive, states: @rules[rule].states)
    @automaton = new Automaton(grid, @rules[rule].rule, @step_time)
    @_set_up_controls()
    @_set_up_color_rules(@rules[rule].colors)

  _set_up_controls: ->
    @_controls_container().empty()
    @_set_up_control_buttons()
    @_set_up_menu()

  _set_up_menu: ->
    @_controls_container().append @_menu()

  _menu: -> @_responding_to_changes @_with_rule_options(@_new_menu())
  
  _new_menu: -> jQuery('<select/>', id: 'menu')

  _responding_to_changes: (menu) ->
    menu.change => @start(rule: menu.val())

  _with_rule_options: (menu) ->
    _.each _.keys(@rules), (rule_name) =>
      menu.append @_menu_item_for(rule_name)
    menu

  _menu_item_for: (rule_name) ->
    jQuery('<option/>', value: rule_name, text: @rules[rule_name].name)

  _set_up_control_buttons: ->
    _.each ['start', 'stop', 'step', 'clear'], (option) =>
      @_controls_container().append(@_control_button_for(option))

  _control_button_for: (option) ->
    button = jQuery('<button/>', id: option, text: @_capitalize(option))
    button.on 'click', => @automaton[option]()
    button

  _capitalize: (text) ->
    text.charAt(0).toUpperCase() + text.slice(1);

  _grid_container: ->
    @grid_container ||= @_existing_grid_container() || @_new_grid_container()

  _controls_container: ->
    @controls_container ||= @_existing_controls_container() || @_new_controls_container()

  _existing_controls_container: ->
    controls_container = @container.find('#controls_container')
    return unless controls_container.length > 0
    controls_container

  _new_controls_container: ->
    jQuery('<div/>', id: 'controls_container').appendTo(@container)

  _existing_grid_container: ->
    grid_container = @container.find('#grid_container')
    return unless grid_container.length > 0
    grid_container

  _new_grid_container: ->
    jQuery('<div/>', id: 'grid_container').appendTo(@container)

  _set_up_color_rules: (colors) ->
    @_clear_existing_color_rules()
    @_add_color_rules_for(colors)

  _add_color_rules_for: (colors) ->
    _.each colors, (color, index) =>
      @_add_color_rule(color: color, index: index)

  _clear_existing_color_rules: ->
    @container.find('style').remove()

  _add_color_rule: ({ color: color, index: index }) ->
    jQuery("<style>[data-state='#{index}'] { background-color: #{color}; }</style>").appendTo(@container)
