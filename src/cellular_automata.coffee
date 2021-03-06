class @CellularAutomata
  DEFAULT_HEIGHT = 30
  DEFAULT_WIDTH = 50
  DEFAULT_STEP_TIME = 100

  constructor: ({ container: @container, rules: @rules, height: @height, width: @width, interactive: @interactive, step_time: @step_time }) ->
    @height ||= DEFAULT_HEIGHT
    @width ||= DEFAULT_WIDTH
    @step_time ||= DEFAULT_STEP_TIME
    @interactive = true unless @interactive?

  render: ({ rule: rule_name }) ->
    @container.empty()
    @_set_up_automaton_for(rule_name)
    @_set_up_control_buttons()
    @_set_up_menu(rule_name)
    @_set_up_color_rules_for(rule_name)

  _set_up_automaton_for: (rule_name) ->
    @automaton = @_automaton_for(@rules[rule_name])

  _set_up_control_buttons: ->
    @_control_buttons().set_up()

  _set_up_menu: (starting_rule) ->
    @_menu(starting_rule).set_up()

  _set_up_color_rules_for: (rule_name) ->
    @_color_rules_for(@rules[rule_name].colors).set_up()

  _control_buttons: ->
    new ButtonControls(container: @container, automaton: @automaton)

  _menu: (starting_rule) ->
    new MenuControls(container: @container, starting_rule: starting_rule, rules: @rules, render: ((options) => @render(options)))

  _color_rules_for: (colors) ->
    new ColorRules(container: @container, colors: colors)

  _automaton_for: (rule) ->
    new Automaton(@_grid_for(rule), rule.rule, @step_time)

  _grid_for: (rule) ->
    new Grid(@container, @_grid_options(rule))

  _grid_options: (rule) ->
    height: @height
    width: @width
    interactive: @interactive
    states: rule.states
