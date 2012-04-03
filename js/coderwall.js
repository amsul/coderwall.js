
/* 
  Author:                 Amsul
  Author URI:             http://amsul.ca
  Description:            Displays Coderwall badges for your team
  Version:                0.0.5 alpha
  Created on:             31/03/2012
  Last Updated:           03 April, 2012
*/

(function() {
  var CodersWall, Fetcher;

  window.$ = jQuery;

  CodersWall = {
    init: function(options, coderBox) {
      var self;
      self = this;
      self.box = coderBox;
      self.$box = $(coderBox);
      self.options = $.extend({}, $.fn.teamCoderwall.options, options);
      self.team = (typeof options !== 'undefined' ? options.team : self.options.team);
      self.compileBadges();
      return self;
    },
    compileBadges: function() {
      var badgeFetcher, coder, fetcher, i, self, teamFetcher, _i, _len, _len2, _ref, _ref2;
      self = this;
      teamFetcher = new Fetcher();
      teamFetcher.requests = [];
      badgeFetcher = function(coder, i) {
        return teamFetcher.requests[i] = teamFetcher.getBadges(coder);
      };
      _ref = self.team;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        coder = _ref[i];
        badgeFetcher(coder, i);
      }
      _ref2 = teamFetcher.requests;
      for (_i = 0, _len2 = _ref2.length; _i < _len2; _i++) {
        fetcher = _ref2[_i];
        self.coderFetcher(fetcher);
      }
      return self;
    },
    coderFetcher: function(fetcher) {
      var self;
      self = this;
      self.coderFetcher.count = 0;
      fetcher.done(function(coder, response) {
        self.storeTeamBadges(coder, response);
        return this;
      });
      return self;
    },
    storeTeamBadges: function(coder, response) {
      var badge, badgeName, self, _i, _len, _ref;
      self = this;
      if (response === 'success') {
        _ref = coder.data.badges;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          badge = _ref[_i];
          badgeName = badge.name;
          if (typeof self.teamBadges[badgeName] === 'undefined') {
            self.teamBadges[badgeName] = badge;
            self.teamBadges[badgeName].coders = [coder.data.username];
            self.teamBadges[badgeName].count = 1;
          } else {
            self.teamBadges[badgeName].coders.push(coder.data.username);
            self.teamBadges[badgeName].count += 1;
          }
        }
      }
      self.coderFetcher.count += 1;
      if (self.team.length === self.coderFetcher.count) {
        self.printBadges(self.teamBadges, self.team);
      }
      return self;
    },
    printBadges: function(teamBadges, team) {
      var badge, badgeSize, coder, compileCoderList, compileList, self, teamBadgesList, _i, _len;
      self = this;
      badgeSize = self.options.badge_size;
      compileList = function(badge, badgeObj) {
        return '<li class="box-badge">\
        <div class="badge-icon' + (badgeObj.count > 1 ? ' show-count' : '') + '" data-count="' + badgeObj.count + '"><img width="' + badgeSize + '" height="' + badgeSize + '" alt="' + badge + '" data-title="' + badgeObj.description + '" src="' + badgeObj.badge + '"></div>\
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
      teamBadgesList += '<div class="team-coders"><strong>Badges achieved by:&nbsp;</strong>';
      for (_i = 0, _len = team.length; _i < _len; _i++) {
        coder = team[_i];
        teamBadgesList += compileCoderList(coder);
      }
      teamBadgesList += '</div>';
      self.$box.html(teamBadgesList).show();
      return self;
    },
    teamBadges: {}
  };

  Fetcher = (function() {

    function Fetcher() {}

    Fetcher.prototype.init = function() {};

    Fetcher.prototype.getBadges = function(coder) {
      return $.ajax({
        url: 'http://coderwall.com/' + coder + '.json',
        dataType: 'jsonp'
      });
    };

    return Fetcher;

  })();

  $.fn.teamCoderwall = function(options) {
    return this.each(function() {
      var coderwall;
      coderwall = Object.create(CodersWall);
      coderwall.init(options, this);
      return this;
    });
  };

  $.fn.teamCoderwall.options = {
    team: ['amsul', 'maxpresman'],
    badge_size: 72
  };

}).call(this);
