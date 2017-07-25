class @ColorRules

  constructor: ({ container: @container, colors: @colors }) ->

  set_up: ->
    @_clear_existing_color_rules()
    @_add_color_rules_for(@colors)

  _clear_existing_color_rules: ->
    @container.find('style').remove()

  _add_color_rules_for: (colors) ->
    _.each colors, (color, index) =>
      @_add_color_rule(color: color, index: index)

  _add_color_rule: ({ color: color, index: index }) ->
    jQuery("<style>[data-state='#{index}'] { background-color: #{color}; }</style>").appendTo(@container)
