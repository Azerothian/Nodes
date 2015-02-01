express = require "express"
React = require "react"
path = require "path"
debug = require "debug"
Promise = require "bluebird"
cluster = require "cluster"

debug.enable "*"

require 'coffee-react/register' # add cjsx require
require './util/cson-register'


if cluster.isMaster
  cpuCount = 1#require("os").cpus().length * 1
  for i in [0...cpuCount]
    cluster.fork()
  return


routerFactory = require "./router/server"
bros = require "./bros"
logger = require("./util/logger")("nodes:");

pathToConfigFile = "./"

pathToConfigFile = process.argv[2] if process.argv[2]?

sitePath = path.resolve process.cwd(), pathToConfigFile #, "index.cson"
logger.info "Site found at '#{sitePath}'"

site = require(sitePath)
site.cwd = sitePath

logger.info "site file loaded", site

if !site.express
  site.express = {}

site.express.modules = require(path.resolve(sitePath, "express-modules"))

logger.info "express modules loaded", site.express.modules

expressApp = express()

site.components = {}

for key,value of site.layouts
  if !site.components[value]
    site.components[value] = require path.join(site.cwd, value)

for appName, app of site.apps
  for key, value of app.routes
    for r in value.components
      if !site.components[r]
        site.components[r] = require path.join(site.cwd, r)

logger.log "site components", site.components
renderer = routerFactory(site)

startup = () ->
  return new Promise (resolve, reject) ->
    if site.static?
      staticPath = path.resolve(sitePath, site.static)
      logger.info "creating static handler at '#{staticPath}"
      expressApp.use express.static(staticPath)
    
    promises = []
    for appName, app of site.apps
      
      p = bros(site, appName, app).then (tmpDir) ->
        logger.log "creating path to '#{tmpDir}"
        expressApp.use express.static(tmpDir)
        modules = []
        if site.modules?
          modules = modules.concat site.modules
        if app.modules?
          modules = modules.concat app.modules
        appModules = []
        logger.debug "modules for route #{appName}", modules
        for m in modules
          if site.express.modules[m]?
            appModules.push site.express.modules[m]
        
        {routes, routeFunc} = renderer.createApplication appName, app
        
        for r in routes
          expressArgs = [r]
          expressArgs = expressArgs.concat appModules
          expressArgs.push routeFunc
          
          logger.debug "args for app #{appName}", expressArgs
          expressApp.use.apply expressApp, expressArgs
      promises.push p
      
      
      
      
    Promise.all(promises).then resolve, reject
      
startup().then () ->
  expressApp.listen site.express.port