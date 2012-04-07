# do the demo stuff

form = $('#submit_team')
teamBox = $('#team_coderwall')


# when you click the buttons, do things

form.find('button').on('click', (e) ->
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
    coders = form.serializeArray()

    # get badges only for names entered
    getBadgesFor = (codername) -> if codername.length then team.push codername

    getBadgesFor coders[name].value for name of coders
  
    # if there's no team, alert it
    if not team.length
      alert 'Enter at least one Coderwall username'
      form.find('input:text').first().focus()

    # otherwise do stuff with the team
    else
      if type is 'show_badges'
        # get the team's coderwall badges and print
        teamBox.codersWall
          team: team
          badge_size: 128

      else if type is 'get_script'
        # place a script for embedding
        scriptTags = '<textarea onmouseup="this.select()">&lt;script src="//amsul.github.com/coderwall.js/js/coderwall.min.js">&lt;/script>&lt;script id="coderscript">!function($,d){$("<div/>").insertBefore(d.getElementById("coderscript")).codersWall({team:[' + JSON.stringify(team) + ']})}(jQuery,document);&lt;/script>​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​</textarea>'
        form.find('#script_box').html(scriptTags)

  # stop form submission
  e.preventDefault()
  return false

)

form.find('.remove').live('click', ->
  # remove this dude
  $(this).parent().remove()
)





