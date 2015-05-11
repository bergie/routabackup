noflo = require 'noflo'
url = require 'url'

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'in',
    datatype: 'string'
  c.inPorts.add 'pageurl',
    datatype: 'string'
    required: yes
  c.outPorts.add 'out',
    datatype: 'string'
    
  noflo.helpers.WirePattern c,
    in: 'in'
    params: ['pageurl']
    out: 'out'
    async: true
    forwardGroups: true
  , (data, groups, out, callback) ->
    parsed = url.parse c.params.pageurl
    if data.indexOf(parsed.path) is -1
      return callback()
    if data.indexOf('startfrom') is -1
      return callback()
    
    out.send data
    do callback
    
  c