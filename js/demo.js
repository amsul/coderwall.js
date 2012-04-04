(function() {
  var form, teamBox;

  form = $('#submit_team');

  teamBox = $('#team_coderwall');

  form.find('button').each(function(count, button) {
    return $(button).on('click', function(e) {
      var $this, clone, coders, getBadgesFor, name, parent, team, type;
      $this = $(this);
      type = $this.data('type');
      if (type === 'add_coder') {
        parent = $this.parent();
        clone = parent.prev('.fieldbox').clone();
        clone.find('input').val('');
        parent.before(clone);
      } else {
        team = [];
        getBadgesFor = function(codername) {
          if (codername.length) return team.push(codername);
        };
        coders = form.serializeArray();
        for (name in coders) {
          getBadgesFor(coders[name].value);
        }
        teamBox.teamCoderwall({
          team: team,
          badge_size: 128
        });
      }
      e.preventDefault();
      return false;
    });
  });

  form.find('.remove').live('click', function() {
    return $(this).parent().remove();
  });

}).call(this);
