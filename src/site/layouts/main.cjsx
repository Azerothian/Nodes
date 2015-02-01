React = require "react"
module.exports = React.createClass {
 
  render: () ->
    <html>
      <head>
        {@props.header}
      </head>
      <body>
        {@props.children}
      </body>
    </html>
  
}