###
  Author:                 Amsul
  Author URI:             http://amsul.ca
  Description:            Displays Coderwall badges for your team
  Version:                1.0
  Created on:             31/03/2012
  Last Updated:           10 April, 2012
###


##################################
## reset jquery

window.$ = jQuery




##################################
## jsonp error support

`
// jquery.jsonp 1.0.4 (c) 2009 Julian Aubourg | MIT License
// http://code.google.com/p/jquery-jsonp/
(function(g){function e(){}function v(F){d=[F]}function o(J,G,H,I){try{I=J&&J.apply(G.context||G,H)}catch(F){I=!1}return I}function n(F){return/\?/.test(F)?"&":"?"}var p="async",t="charset",r="",D="error",u="insertBefore",s="_jqjsp",A="on",h=A+"click",k=A+D,q=A+"load",y=A+"readystatechange",b="readyState",C="removeChild",j="<script>",z="success",B="timeout",f=window,a=g.Deferred,i=g("head")[0]||document.documentElement,c=i.firstChild,x={},m=0,d,l={callback:s,url:location.href},w=f.opera;function E(J){J=g.extend({},l,J);var H=J.success,O=J.error,G=J.complete,X=J.dataFilter,Z=J.callbackParameter,P=J.callback,Y=J.cache,F=J.pageCache,I=J.charset,K=J.url,ab=J.data,R=J.timeout,N,V=0,T=e,Q,M,aa,L,U;a&&a(function(ac){ac.done(H).fail(O);H=ac.resolve;O=ac.reject}).promise(J);J.abort=function(){!(V++)&&T()};if(o(J.beforeSend,J,[J])===!1||V){return J}K=K||r;ab=ab?((typeof ab)=="string"?ab:g.param(ab,J.traditional)):r;K+=ab?(n(K)+ab):r;Z&&(K+=n(K)+encodeURIComponent(Z)+"=?");!Y&&!F&&(K+=n(K)+"_"+(new Date()).getTime()+"=");K=K.replace(/=\?(&|$)/,"="+P+"$1");function W(ac){if(!(V++)){T();F&&(x[K]={s:[ac]});X&&(ac=X.apply(J,[ac]));o(H,J,[ac,z]);o(G,J,[J,z])}}function S(ac){if(!(V++)){T();F&&ac!=B&&(x[K]=ac);o(O,J,[J,ac]);o(G,J,[J,ac])}}if(F&&(N=x[K])){N.s?W(N.s[0]):S(N)}else{f[P]=v;aa=g(j)[0];aa.id=s+m++;if(I){aa[t]=I}w&&w.version()<11.6?((L=g(j)[0]).text="document.getElementById('"+aa.id+"')."+k+"()"):(aa[p]=p);if(y in aa){aa.htmlFor=aa.id;aa.event=h}aa[q]=aa[k]=aa[y]=function(ac){if(!aa[b]||!/i/.test(aa[b])){try{aa[h]&&aa[h]()}catch(ad){}ac=d;d=0;ac?W(ac[0]):S(D)}};aa.src=K;T=function(ac){U&&clearTimeout(U);aa[y]=aa[q]=aa[k]=null;i[C](aa);L&&i[C](L)};i[u](aa,c);L&&i[u](L,c);U=R>0&&setTimeout(function(){S(B)},R)}return J}E.setup=function(F){g.extend(l,F)};g.jsonp=E})(jQuery);
`




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
    
    # request each coders badges and collect the coders' requests
    self.teamFetcher = (coder, count) ->
                      $.jsonp
                        url: 'http://coderwall.com/' + coder + '.json?callback=?'
                        cache: true
                        success: (coder, resp) ->
                          self.storeTeamBadges(coder, resp)
                        error: (req, resp) ->
                          # if get fails, just increment the count n move on
                          self.storeTeamBadges(coder, resp)

    self.teamFetcher.count = 0
    self.teamFetcher.requests = []

    # create a badge fetcher for each coder and put it in the collection
    badgeFetcher = (coder, i) ->
      self.teamFetcher.requests[i] = self.teamFetcher(coder, self.teamFetcher.count)

    # loop through the team and bind the badge fetcher
    badgeFetcher coder, i for coder, i in self.team

    return self
  #compileBadges


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
    self.teamFetcher.count += 1

    # if it's the final request coming through, then print the team badges
    self.printBadges self.teamBadges, self.team if self.team.length is self.teamFetcher.count

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








