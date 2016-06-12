@load_rule = (rule) ->
  clear_grid()
  load_color_rules(rule.colors)
  load_automaton_for(rule)

load_color_rules = (color_rules) ->
  jQuery('style').remove()
  _.each color_rules, (color, state) -> load_color_rule(state, color)

clear_grid = -> jQuery('#grid_container').empty()

load_automaton_for = (rule) ->
  automaton = automaton_for(rule)
  set_up_controls_for(automaton)

automaton_for = (rule) ->
  grid = new Grid(jQuery('#grid_container'), height: 30, width: 50, interactive: true, states: rule.states)
  automaton = new Automaton(grid, rule.rule, 100)

set_up_controls_for = (automaton) ->
  jQuery('#start').off()
  jQuery('#stop').off()
  jQuery('#step').off()
  jQuery('#clear').off()

  jQuery('#start').click  -> automaton.start()
  jQuery('#stop').click   -> automaton.stop()
  jQuery('#step').click   -> automaton.step()
  jQuery('#clear').click  -> automaton.clear()

load_color_rule = (state, color) ->
  jQuery("<style>[data-state='#{state}'] { background-color: #{color}; }</style>").appendTo('head')

@display_menu = ->
  menu = jQuery('<select/>', id: 'menu')
  _.each _.keys(@rules), (rule_name) ->
    menu.append(jQuery('<option/>', value: rule_name, text: @rules[rule_name].name))

  menu.change => @load_rule(@rules[menu.val()])

  jQuery('#controls').append(menu)

$ =>
  @display_menu()
  @load_rule(@rules.conways_game_of_life)
