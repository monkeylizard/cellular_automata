# CellularAutomata
Web-based cellular automata

From [Wikipedia](https://en.wikipedia.org/wiki/Cellular_automaton):

"A cellular automaton consists of a regular grid of cells, each in one of a finite number of states, such as on and off (in contrast to a coupled map lattice). The grid can be in any finite number of dimensions. For each cell, a set of cells called its neighborhood is defined relative to the specified cell. An initial state (time t = 0) is selected by assigning a state for each cell. A new generation is created (advancing t by 1), according to some fixed rule (generally, a mathematical function) that determines the new state of each cell in terms of the current state of the cell and the states of the cells in its neighborhood."

`CellularAutomata` is a customizeable coffeescript framework for visualizing cellular automata. To see a demo of it, click [here](https://monkeylizard.github.io/cellular_automata/). The demo includes four pre-build cellular automata:

* [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
* [Fire propagation](http://pcg.wikidot.com/pcg-algorithm:fire-propagation)
* [Wire World](https://en.wikipedia.org/wiki/Wireworld)
* [Rule 110](https://en.wikipedia.org/wiki/Rule_110)

# Setup

You can download a pre-built version of the code [here](https://github.com/monkeylizard/cellular_automata/blob/master/build/cellular_automata.js).

`CellularAutomata` has two dependencies: jQuery, and underscore.js. It should work with most versions of those libraries, but was built using [jQuery 3.0.0](https://code.jquery.com/jquery-3.0.0.min.js) and [underscore 1.8.3](https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js), so if you have any issues, try using those.

# Simple Example

To render a cellular automaton, instantiate a `CellularAutomata` instance, and call `render` on it. The constructor of `CellularAutomata` accepts an options object that we will supply with two values: `container`, which is a jQuery-selected `div`, and `rules`, which is an object containing the rules we want to visualize. The `render` method is then called with the key of the rule we want to show first.

```javascript
rules = {
  on_off: {
    name: "On-Off",
    states: 2,
    colors: ['black', 'white'],
    rule: function(x, y, grid) {
      current_value = grid.is_on({ x: x, y: y })
      return !current_value
    }
  }
}

container = jQuery('#container')

new CellularAutomata({ rules: rules, container: container }).render('on_off')
```

The `CellularAutomata` then creates a grid, control buttons, and a rules menu inside of the given container. In the grid, the cells will change color at each step according to the rule given. The control buttons allow you to start the automaton, stop it, advance it one step, and clear the grid. If we had included more than one rule, the rules menu would allow us to switch between the rules that we had created.

In this example, we have created an automaton that simply alternates whether a given cell is off or on, and renders it as black or white, respectively. Before starting the visualization, you can turn individual cells on or off by clicking on them. Then by pressing the "start" button, the automaton will render a new step, at a default rate of one step per 100 milliseconds.

# Defining Rules

The `rules` object given to the `CeullularAutomata` constructor takes the form of a nested JavaScript object. Each rule is specified by a key, which is the value passed into `CellularAutomata#render` to specify which rule should be displayed to begin with (in the case of the example above, that would be `"on_off"`). Nested beneath that key, each rule has four properties:
* `name` - this is the display name of the rule. It is what will be shown in the rule selection menu.
* `states` - this is the number of allowed states of cells in this rule. Many cellular automata are binary, such as the above example, and Conway's Game of Life, but some allow other numbers of states. For example, my implementation of fire propagation uses 7 states, which specify when a cell is normal (0), blocked (1), burning (2-5), or burned out (6), and Wire World uses four states, indicating whether a cell is background (0), wire (1), electron head (2), or electron tail (3).
* `colors` - this is an array of the colors that the cell should take on for each state. These values are strings containing any valid css color, including standard color names, hex values, and rgb values. Additionally note that if you want the cell to be the same color as the background, you can specify `"inherit"`, which is the css property that says it should take on the value its parent has.
* `rule` - this is a function that specifies what the next value of a cell should be, based on the current state of the grid. This function is applied to every cell in the grid at each step, and the new values are applied simultaneously, after they have all been computed. The function accepts three arguments, `x`, `y`, and `grid`, and returns an integer that is the next value of the cell. `x` and `y` are the coordinates of the cell in question, with `(0, 0)`, being the upper leftmost cell, and advancing down and to the right. The `grid` parameter is an instance of `Grid`, which is a class representing the current state of the grid. `Grid` class has one public method, `state`, which returns the current state of a given cell, and is called using an options object with keys for `x` and `y`, like so: `grid.state({ x: 5, y: 7 })`.

# Configuring `CellularAutomata`

The `CellularAutomata` object is highly configurable. When constructing it, only the `rules` and `container` parameters are required, but many more options can be specified. A complete list of the allowed options that can be specified is as follows:
* `rules` - the rules you wish to visualize. This argument is required.
* `container` - the container in which to render the grid and controls. This argument is required.
* `height` - the height of the grid, in cells. The default height is 30.
* `width` - the width of the grid, in cells. The default width is 50.
* `interactive` - whether or not cells' states can be changed by clicking on them. The default value is `true`.
* `step_time` - the amount of time to wait between steps, in milliseconds. The default value is 100.

# Example Ruleset

For reference, this is the rules object used in the demo page, defining Conway's Game of Life, Fire Propagation, Wire World, and Rule 110.

```coffeescript
rules =
  conways_game_of_life:
    name: "Conway's Game of Life"
    states: 2
    colors: ['inherit', '#E8107C']
    rule: (x, y, grid) ->
      self      = grid.is_on(x: x, y: y)
      northwest = grid.is_on(x: x - 1,  y: y - 1)
      north     = grid.is_on(x: x,      y: y - 1)
      northeast = grid.is_on(x: x + 1,  y: y - 1)

      west      = grid.is_on(x: x - 1,  y: y)
      east      = grid.is_on(x: x + 1,  y: y)

      southwest = grid.is_on(x: x - 1,  y: y + 1)
      south     = grid.is_on(x: x,      y: y + 1)
      southeast = grid.is_on(x: x + 1,  y: y + 1)

      number_of_live_neighbors = _.compact([northwest, north, northeast, west, east, southwest, south, southeast]).length

      switch
        when number_of_live_neighbors == 3 then true
        when number_of_live_neighbors < 2 then false
        when number_of_live_neighbors > 3 then false
        else self

  fire_propagation:
    name: 'Fire Propagation'
    states: 7
    colors: ['inherit', 'black', '#ED6509', '#ED6509', '#ED6509', '#ED6509', '#632E0A']
    rule: (x, y, grid) ->
      NORMAL      = 0
      FIREBREAK   = 1
      FIRESTART   = 2
      BURNED_OUT  = 6

      self = grid.state(x: x, y: y)

      return FIREBREAK if self == FIREBREAK
      return Math.min(self + 1, BURNED_OUT) if self > FIREBREAK

      northwest = grid.state(x: x - 1,  y: y - 1)
      north     = grid.state(x: x,      y: y - 1)
      northeast = grid.state(x: x + 1,  y: y - 1)

      west      = grid.state(x: x - 1,  y: y)
      east      = grid.state(x: x + 1,  y: y)

      southwest = grid.state(x: x - 1,  y: y + 1)
      south     = grid.state(x: x,      y: y + 1)
      southeast = grid.state(x: x + 1,  y: y + 1)
    
      neighbors = [northwest, north, northeast, west, east, southwest, south, southeast]
      number_of_burning_neighbors = _.size(_.filter(neighbors, (neighbor) -> neighbor > FIREBREAK && neighbor < BURNED_OUT))

      chance_of_catching_fire = number_of_burning_neighbors * 1 / 8

      return FIRESTART if Math.random() < chance_of_catching_fire
      self

  wire_world:
    name: 'Wire World'
    states: 4
    colors: ['inherit', 'black', 'yellow', 'orange']
    rule: (x, y, grid) ->
      BACKGROUND = 0
      WIRE = 1
      HEAD = 2
      TAIL = 3

      self = grid.state(x: x, y: y)

      return BACKGROUND if self == BACKGROUND
      return TAIL if self == HEAD
      return WIRE if self == TAIL

      northwest = grid.state(x: x - 1,  y: y - 1)
      north     = grid.state(x: x,      y: y - 1)
      northeast = grid.state(x: x + 1,  y: y - 1)

      west      = grid.state(x: x - 1,  y: y)
      east      = grid.state(x: x + 1,  y: y)

      southwest = grid.state(x: x - 1,  y: y + 1)
      south     = grid.state(x: x,      y: y + 1)
      southeast = grid.state(x: x + 1,  y: y + 1)

      neighbors = [northwest, north, northeast, west, east, southwest, south, southeast]

      number_of_active_neighbors = _.size(_.filter(neighbors, (neighbor) -> neighbor == HEAD))

      return HEAD if number_of_active_neighbors == 1 || number_of_active_neighbors == 2

      WIRE

  rule_110:
    name: 'Rule 110'
    states: 2
    colors: ['inherit', '#E8107C']
    rule: (x, y, grid) ->
      self = grid.state(x: x, y: y)
      return 1 if self

      northwest = grid.state(x: x - 1,  y: y - 1)
      north     = grid.state(x: x,      y: y - 1)
      northeast = grid.state(x: x + 1,  y: y - 1)

      outcomes = [0,1,1,1,0,1,1,0]

      value = parseInt([northwest, north, northeast].join(''), 2)
      outcomes[value] || 0
```
