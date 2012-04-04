# do the demo stuff

form = $('#submit_team')
teamBox = $('#team_coderwall')


# when you click the buttons, do things

form.find('button').each( (count, button) ->

  $(button).on('click', (e) ->
    $this = $(this)

    # such as finding out which one was clicked.
    type = $this.data('type')

    if type is 'add_coder'
      parent = $this.parent()

      clone = parent.prev('.fieldbox').clone()
      clone.find('input').val('')

      parent.before(clone)
    
    else
      # collect the team
      team = []
      getBadgesFor = (codername) ->
        if codername.length then team.push codername

      coders = form.serializeArray()
      getBadgesFor coders[name].value for name of coders

      teamBox.teamCoderwall
        team: team
        badge_size: 128

    # stop form submission
    e.preventDefault()
    return false
  )

)

form.find('.remove').live('click', ->
  # remove this dude
  $(this).parent().remove()
)





