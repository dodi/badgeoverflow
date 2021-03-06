class Dashing.Site extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered
    $('#bigtext').bigtext({
      minfontsize: 24,
      maxfontsize: 32
    })

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.