Promise = require "bluebird";
url = require 'url'
Module = require "../lib/module";
Promises = require "../lib/Promises";
util = require "util"
SessionSockets = require './lib/session.socket.io'

class Sockets extends Module
  constructor: (@options) ->
    super; # call this to make sure everything is set;
    @log "Illisian - Sockets Module - Constructor"
  onAppConfig: (expressApp) =>
    return new Promise (resolve, reject) =>
      @log "Illisian - Sockets Module - onAppConfig"

      resolve();
  onAppStart: (expressApp, server) =>
    return new Promise (resolve, reject) =>
      @io = require('socket.io').listen(server);
      @session = new SessionSockets @io, @core.config.sessions.store, @core.config.sessions.cookie;
      
      @session.on "connection", (err, socket, session, info) =>
        uri = url.parse "http://#{info.host}";
        @core.sites.get(info.cookie, uri.hostname).then (site) =>
          @log "fireing onSocketStart", site.events.onSocketStart.length;
          return site.events.onSocketStart.chain(@session).then () =>
            @log "fireing onSocketStart - complete";
            

          
      resolve();  
  
  onSocketStart: (session) =>
    @log "inner onSocketStart";
  ###
  -- Memory Gap --
  ###
  
  onPageLoad: (req, res, page) =>
    return new Promise (resolve, reject) =>
      page.sockets = {};
      resolve();
  
  onSiteLoad: (req, res, site) =>
    return new Promise (resolve, reject) =>
      site.events.onSocketStart = new Promises();
      site.refreshEvents("onSocketStart").then () =>
        return resolve();
      , reject
    

module.exports = Sockets;