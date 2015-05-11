noflo = require 'noflo'
superagent = require 'superagent'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'download'
  c.inPorts.add 'in',
    datatype: 'string'
    description: 'URL'
  c.outPorts.add 'out',
    datatype: 'string'
  c.outPorts.add 'error',
    datatype: 'object'
    
  noflo.helpers.WirePattern c,
    in: 'in'
    out: 'out'
    async: true
    forwardGroups: true
  , (data, groups, out, callback) ->
    superagent.get data
    .end (err, res) ->
      return callback err if err
      out.send res.text
      do callback
    
  c