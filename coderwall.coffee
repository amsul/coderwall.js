### 
  Author:                 Amsul
  Author URI:             http://amsul.ca
  Description:            Displays Coderwall badges for your team
  Version:                0.0.2 alpha
  Created on:             31/03/2012
  Last Updated:           01 April, 2012
###  


##################################
## set globals n reset jquery

window.$ = jQuery
window.teamBadges = {}




##################################
## create the fetcher class

class Fetcher

  init: ->

  # fetch badges from coderwall
  getBadges: (coder) ->
    $.ajax
      url: 'http://coderwall.com/' + coder + '.json'
      method: 'get'
      dataType: 'jsonp'
  #badges





##################################
# begin team coderwall

window.CodersWall =

  init: (options, coderBox) ->
    self = this

    self.box = coderBox
    self.$box = $ coderBox
    CodersWall.team = options.team
    
    self.compileBadges CodersWall.team

    return self


  # create an array out of the coder badges
  compileBadges: (team) ->
    self = this

    # set an empty array for collecting the coders' ajax requests
    coders = []

    # create a new instance of the Fetcher
    teamFetcher = new Fetcher()

    # create a badge fetcher for each coder and put it in the collection
    getBadges = (coder, i) ->
      coders[i] = teamFetcher.getBadges coder

    # loop through the team and bind the badge fetcher
    getBadges coder, i for coder, i in team


    ##################################


    # create a new callback for each coder's fetcher
    coderFetcher = (fetcher, j) ->

      # when the fetcher is complete, do stuff
      fetcher.done (coder, response) ->

        # if it's a successful get, loop through coder badges
        if response is 'success'

          # loop the badges and add them to the team badge obj
          for badge in coder.data.badges

            # if this badge isn't already there, put it there
            if typeof teamBadges[badge.name] is 'undefined'
              teamBadges[badge.name] = badge
              teamBadges[badge.name].coders = [ coder.data.username ]
              teamBadges[badge.name].count = 1

            # otherwise just increase the count
            else
              teamBadges[badge.name].coders.push( coder.data.username )
              teamBadges[badge.name].count += 1


        # increase the fetcher count
        coderFetcher.count += 1

        # if it's the final pass through, print the team badges
        self.printBadges teamBadges if team.length is coderFetcher.count

        return this
    #coderFetcher

    # set the initial count to 0
    coderFetcher.count = 0

    # go through the coder fetchers and assign the callback
    coderFetcher fetcher, j for fetcher, j in coders

    return self
  #compileBadges


  # print the team's badges
  printBadges: (teamBadges) ->
    self = this

    # compile this badge into a list of all badges
    compileList = (badge, badgeObj) ->

      # show the counter only if there's more than one of a badge
      showcount = if badgeObj.count > 1 then ' show-count' else ''

      '<li class="box-badge">
        <div class="badge-icon' + showcount + '" data-count="' + badgeObj.count + '"><img width="72" height="72" alt="' + badge + '" data-title="' + badgeObj.description + '" src="' + badgeObj.badge + '"></div>
        <div class="badge-name">' + badge + '</div>
      </li>'
    #compileList

    # loop through the badges and compile them
    teamBadgesList = '<ul id="team_box">'
    teamBadgesList += compileList badge, teamBadges[badge] for badge of teamBadges
    teamBadgesList += '</ul>'

    # compile the coder usernames into a list of their coderwall profiles
    compileCoderList = (coder) ->
      '<a href="http://coderwall.com/' + coder + '" target="_blank">' + coder + '</a>'

    # add the team coder names as a footer
    teamBadgesList += '<div class="team-coders"><strong>Badges achieved by:&nbsp;</strong>'
    teamBadgesList += compileCoderList coder for coder in CodersWall.team
    teamBadgesList += '</div>'
    
    # paint the team badges onto the page
    self.$box.html(teamBadgesList).show()

    return self
  #printBadges




##################################
# bind teamCoderWall

$.fn.teamCoderwall = (options) ->
  this.each ->

    # create a new instance and init
    coderwall = Object.create CodersWall
    coderwall.init(options, this)

    return this


# set the default options
$.fn.teamCoderwall.options =
  team: ['amsul', 'maxpresman']








