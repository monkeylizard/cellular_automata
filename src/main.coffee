$ ->
  grid_container = jQuery('<div/>', id: 'grid_container')
  jQuery('body').append(grid_container)

  window.grid = new Grid(grid_container, height: 20, width: 20)
