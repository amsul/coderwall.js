(function() {
  var form, teamBox;

  form = $('#submit_team');

  teamBox = $('#team_coderwall');

  form.find('button').on('click', function(e) {
    var $this, clone, coders, getBadgesFor, name, parent, scriptTags, team, type;
    $this = $(this);
    type = $this.data('type');
    if (type === 'add_coder') {
      parent = $this.parent();
      clone = parent.prev('.fieldbox').clone();
      clone.find('input').val('');
      parent.before(clone);
    } else {
      team = [];
      coders = form.serializeArray();
      getBadgesFor = function(codername) {
        if (codername.length) return team.push(codername);
      };
      for (name in coders) {
        getBadgesFor(coders[name].value);
      }
      if (!team.length) {
        alert('Enter at least one Coderwall username');
        form.find('input:text').first().focus();
      } else {
        if (type === 'show_badges') {
          teamBox.codersWall({
            team: team,
            badge_size: 128
          });
        } else if (type === 'get_script') {
          scriptTags = '<textarea onmouseup="this.select()">&lt;script src="//amsul.github.com/coderwall.js/js/coderwall.min.js">&lt;/script>&lt;script id="coderscript">!function($,d){$("<div/>").insertBefore(d.getElementById("coderscript")).codersWall({team:[' + JSON.stringify(team) + ']})}(jQuery,document);&lt;/script>​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​</textarea>';
          form.find('#script_box').html(scriptTags);
        }
      }
    }
    e.preventDefault();
    return false;
  });

  form.find('.remove').live('click', function() {
    return $(this).parent().remove();
  });

}).call(this);
