fs = require "fs"
Promise = require "bluebird"
util = require "util"
class Util
  constructor: () ->

  @unlink: (path) ->
    return new Promise (resolve, reject) ->
      fs.unlink path, (err) ->
        resolve();
  @freeforall: (path) ->
    return new Promise (resolve, reject) ->
      setTimeout () ->
        fs.chmod path, 0x777, () ->
          resolve();
      , 2000
  @log: () ->
    console.log "[#{new Date().toUTCString()}]", util.inspect(arguments);
module.exports = Util;