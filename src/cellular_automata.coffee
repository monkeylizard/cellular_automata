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
    @automaton = @_automaton_for(@rules[rule])
    @_set_up_control_buttons()
    @_set_up_menu()
    @_set_up_color_rules(@rules[rule].colors)

  _automaton_for: (rule) ->
    new Automaton(@_grid_for(rule), rule.rule, @step_time)

  _grid_for: (rule) ->
    new Grid(@container, height: @height, width: @width, interactive: @interactive, states: rule.states)

  _set_up_control_buttons: ->
    @_control_buttons().set_up()

  _set_up_menu: ->
    @_menu().set_up()

  _control_buttons: ->
    new ButtonControls(container: @container, automaton: @automaton)

  _menu: ->
    new MenuControls(container: @container, rules: @rules, start: ((options) => @start(options)))

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
