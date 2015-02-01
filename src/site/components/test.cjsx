React = require "react"
{Link, Navigation} = require "react-router"

logger = require("../util/logger")("nodes:site:components:test")

module.exports = React.createClass {
  mixins: [Navigation]
  getInitialState: () ->
    {
      text: "FOR THE ONE"
    }
  onClick: ->
    @transitionTo("register")
    #@setState { text: "LOL CATS" }
  render: () ->
    logger.log "test render"
    <a onClick={@onClick}>
      {@state.text}
      
    </a>
  
}