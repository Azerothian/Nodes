logger = require("./util/logger")("nodes:site:express-modules:")


module.exports = {
  "logger": (req, res, next) ->
    logger.info "request recieved"
    next()
  "testmodule": (req, res, next) ->
    logger.info "testmodule recieved"
    next()
  
}