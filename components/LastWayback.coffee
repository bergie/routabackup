noflo = require 'noflo'
memento = require 'memento-client'

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'in',
    datatype: 'string'
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
    memento data, (err, available) ->
      return callback err if err
      last = available.filter (a) -> a.rel and a.rel.indexOf('first') isnt -1
      unless last.length
        return callback new Error "No last available for #{data}"
      out.send last[0].href
      do callback
    
  c
