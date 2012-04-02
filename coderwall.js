/* 
  Author:                 Amsul
  Author URI:             http://amsul.ca
  Description:            Displays Coderwall badges for your Coderwall team
  Version:                0 alpha 0.2
  Created on:             31/03/2012
  Last Updated:           01 April, 2012
*/

(function() {
  var Fetcher;

  window.$ = jQuery;

  window.teamBadges = {};

  Fetcher = (function() {

    function Fetcher() {}

    Fetcher.prototype.init = function() {};

    Fetcher.prototype.getBadges = function(coder) {
      return $.ajax({
        url: 'http://coderwall.com/' + coder + '.json',
        method: 'get',
        dataType: 'jsonp'
      });
    };

    return Fetcher;

  })();

  window.CodersWall = {
    init: function(options, coderBox) {
      var self;
      self = this;
      self.box = coderBox;
      self.$box = $(coderBox);
      CodersWall.team = options.team;
      self.compileBadges(CodersWall.team);
      return self;
    },
    compileBadges: function(team) {
      var coder, coderFetcher, coders, fetcher, getBadges, i, j, self, teamFetcher, _len, _len2;
      self = this;
      coders = [];
      teamFetcher = new Fetcher();
      getBadges = function(coder, i) {
        return coders[i] = teamFetcher.getBadges(coder);
      };
      for (i = 0, _len = team.length; i < _len; i++) {
        coder = team[i];
        getBadges(coder, i);
      }
      coderFetcher = function(fetcher, j) {
        return fetcher.done(function(coder, response) {
          var badge, _i, _len2, _ref;
          if (response === 'success') {
            _ref = coder.data.badges;
            for (_i = 0, _len2 = _ref.length; _i < _len2; _i++) {
              badge = _ref[_i];
              if (typeof teamBadges[badge.name] === 'undefined') {
                teamBadges[badge.name] = badge;
                teamBadges[badge.name].coders = [coder.data.username];
                teamBadges[badge.name].count = 1;
              } else {
                teamBadges[badge.name].coders.push(coder.data.username);
                teamBadges[badge.name].count += 1;
              }
            }
          }
          coderFetcher.count += 1;
          if (team.length === coderFetcher.count) self.printBadges(teamBadges);
          return this;
        });
      };
      coderFetcher.count = 0;
      for (j = 0, _len2 = coders.length; j < _len2; j++) {
        fetcher = coders[j];
        coderFetcher(fetcher, j);
      }
      return self;
    },
    printBadges: function(teamBadges) {
      var badge, coder, compileCoderList, compileList, self, teamBadgesList, _i, _len, _ref;
      self = this;
      compileList = function(badge, badgeObj) {
        var showcount;
        showcount = badgeObj.count > 1 ? ' show-count' : '';
        return '<li class="box-badge">\
        <div class="badge-icon' + showcount + '" data-count="' + badgeObj.count + '"><img width="54" height="54" alt="' + badge + '" data-title="' + badgeObj.description + '" src="' + badgeObj.badge + '"></div>\
        <div class="badge-name">' + badge + '</div>\
      </li>';
      };
      teamBadgesList = '<ul id="team_box">';
      for (badge in teamBadges) {
        teamBadgesList += compileList(badge, teamBadges[badge]);
      }
      teamBadgesList += '</ul>';
      compileCoderList = function(coder) {
        return '<a href="http://coderwall.com/' + coder + '" target="_blank">' + coder + '</a>';
      };
      teamBadgesList += '<div class="team-coders"><strong>Achieved by:&nbsp;</strong>';
      _ref = CodersWall.team;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        coder = _ref[_i];
        teamBadgesList += compileCoderList(coder);
      }
      teamBadgesList += '</div>';
      self.$box.html(teamBadgesList).show();
      return self;
    }
  };

  $.fn.teamCoderwall = function(options) {
    return this.each(function() {
      var coderwall;
      coderwall = Object.create(CodersWall);
      coderwall.init(options, this);
      return this;
    });
  };

  $.fn.teamCoderwall.options = {
    team: ['amsul', 'maxpresman']
  };

}).call(this);
