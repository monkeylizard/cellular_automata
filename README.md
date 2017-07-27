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

To render a cellular automaton, instantiate a `CellularAutomata` instance, and call `start` on it. The constructor of `CellularAutomata` accepts an options object that we will supply with two values: `container`, which is a jQuery-selected `div`, and `rules`, which is an object containing the rules we want to visualize. The `start` method is then called with the key of the rule we want to show first.

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

new CellularAutomata({ rules: rules, container: container }).start('on_off')
```

The `CellularAutomata` then creates a grid, control buttons, and a rules menu inside of the given container. In this example, we have created an automaton that simply alternates whether a given cell is off or on, and renders it as black or white, respectively.
