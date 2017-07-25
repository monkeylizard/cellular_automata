class Controls

  constructor: ({ container: container }) ->
    @container = @_controls_container_in(container)

  _controls_container_in: (container) ->
    @_existing_controls_container_in(container) || @_new_controls_container(container)

  _existing_controls_container_in: (container) ->
    controls_container = container.find('#controls_container')
    return unless controls_container.length > 0
    controls_container

  _new_controls_container: (container) ->
    jQuery('<div/>', id: 'controls_container').appendTo(container)

class @ButtonControls extends Controls

  constructor: ({ container: container, automaton: @automaton }) ->
    super(container: container)

  set_up: ->
    @container.empty()
    @_set_up_control_buttons()

  _set_up_control_buttons: ->
    _.each ['start', 'stop', 'step', 'clear'], (option) =>
      @container.append(@_control_button_for(option))

  _control_button_for: (option) ->
    button = jQuery('<button/>', id: option, text: @_capitalize(option))
    button.on 'click', => @automaton[option]()
    button

  _capitalize: (text) ->
    text.charAt(0).toUpperCase() + text.slice(1);

class @MenuControls extends Controls

  constructor: ({ container: container, start: @start, rules: @rules}) ->
    super(container: container)

  set_up: -> @container.append @_menu()

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