noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'in',
    datatype: 'string'
  c.outPorts.add 'out',
    datatype: 'string'
 
  noflo.helpers.WirePattern c,
    in: 'in'
    out: 'out'
    async: true
    forwardGroups: true
  , (data, groups, out, callback) ->
    out.send data.replace /\/web\/[0-9*]+\//g, ''
    do callback
 
  c
