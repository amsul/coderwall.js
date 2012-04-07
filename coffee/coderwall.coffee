###
  Author:                 Amsul
  Author URI:             http://amsul.ca
  Description:            Displays Coderwall badges for your team
  Version:                0.5 beta
  Created on:             31/03/2012
  Last Updated:           04 April, 2012
###


##################################
## reset jquery

window.$ = jQuery





##################################
# begin team coderwall

CodersWall =

  init: (options, coderBox) ->
    self = this

    # store the box
    self.box = coderBox
    self.$box = $ coderBox

    # empty team badges object to collect and store the badges
    self.teamBadges = {}

    self.options = $.extend( {}, $.fn.codersWall.options, options)

    self.team = ( if typeof options isnt 'undefined' then options.team else self.options.team )

    # compile badges for the team provided
    self.compileBadges()

    return self


  # create an array out of the coder badges
  compileBadges: () ->
    self = this

    # create a new instance of the ajax Fetcher and collect the coders' ajax requests
    teamFetcher = new Fetcher()
    teamFetcher.requests = []

    # create a badge fetcher for each coder and put it in the collection
    badgeFetcher = (coder, i) ->
      teamFetcher.requests[i] = teamFetcher.getBadges(coder)

    # loop through the team and bind the badge fetcher
    badgeFetcher coder, i for coder, i in self.team

    # go through the fetchers requests and assign them a callback
    self.coderFetcher fetcher for fetcher in teamFetcher.requests

    return self
  #compileBadges

  # create a callback for each fetcher's request
  coderFetcher: (fetcher) ->
    self = this

    # set the initial fetcher count to 0
    self.coderFetcher.count = 0

    # when the fetcher is complete, store the team badges
    fetcher.done (coder, response) ->
      self.storeTeamBadges(coder, response)
      return this

    return self
  #coderFetcher


  storeTeamBadges: (coder, response) ->
    self = this

    # if it's a successful get, loop through coder badges
    if response is 'success'

      # loop the badges and add them to the team badge obj
      for badge in coder.data.badges
        badgeName = badge.name

        # if this badge doesn't exist, put it there
        if typeof self.teamBadges[badgeName] is 'undefined'
          self.teamBadges[badgeName] = badge
          self.teamBadges[badgeName].coders = [ coder.data.username ]
          self.teamBadges[badgeName].count = 1

        # otherwise just increase the count and add the coder's name
        else
          self.teamBadges[badgeName].coders.push( coder.data.username )
          self.teamBadges[badgeName].count += 1

    # increase the fetcher count
    self.coderFetcher.count += 1

    # if it's the final request coming through, then print the team badges
    self.printBadges self.teamBadges, self.team if self.team.length is self.coderFetcher.count

    return self
  #storeTeamBadges


  # print the team's badges
  printBadges: (teamBadges, team) ->
    self = this

    badgeSize = self.options.badge_size

    # compile this badge into a list of all badges
    compileList = (badge, badgeObj) ->

      # show the counter only if there's more than one of a badge
      '<li class="box-badge"><div class="badge-icon' + ( if badgeObj.count > 1 then ' show-count' else '' ) + '" data-count="' + badgeObj.count + '"><img width="' + badgeSize + '" height="' + badgeSize + '" alt="' + badge + '" data-title="' + badgeObj.description + '" src="' + badgeObj.badge + '"></div><div class="badge-name">' + badge + '</div></li>'
    #compileList

    # loop through the badges and compile them
    teamBadgesList = '<ul id="team_box">'
    teamBadgesList += compileList badge, teamBadges[badge] for badge of teamBadges
    teamBadgesList += '</ul>'


    ################################## 


    # compile the coder usernames into a list of their coderwall profiles
    compileCoderList = (coder) ->
      '<a href="http://coderwall.com/' + coder + '" target="_blank">' + coder + '</a>'

    # add the team coder names as a footer
    teamBadgesList += '<div class="team-coders"><strong>Badges achieved by:&nbsp;</strong>'
    teamBadgesList += compileCoderList coder for coder in team
    teamBadgesList += '</div>'
    
    # paint the team badges onto the page
    self.$box.html(teamBadgesList)

    return self
  #printBadges





##################################
## create the fetcher class

class Fetcher

  init: ->

  # fetch badges from coderwall
  getBadges: (coder) ->
    $.ajax
      url: 'http://coderwall.com/' + coder + '.json'
      dataType: 'jsonp'
  #badges






##################################
# bind codersWall

$.fn.codersWall = (options) ->
  this.each ->

    # create a new instance and init
    coderwall = Object.create CodersWall
    coderwall.init(options, this)

    return this


# default options
$.fn.codersWall.options =
  team: ['amsul', 'maxpresman']
  badge_size: 72








