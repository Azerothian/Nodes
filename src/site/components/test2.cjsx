React = require "react"
{Link, Navigation} = require "react-router"


logger = require("../util/logger")("nodes:site:components:test2")

module.exports = React.createClass {
 
  render: () ->
    logger.log "render test2"
    <Link to="/">
      "Howdy 3"
    </Link>
  
}