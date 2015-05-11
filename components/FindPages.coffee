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
    parsedData = url.parse data
    unless parsedData.path
      return callback()
    if parsedData.path is parsed.path
      return callback()
    if parsedData.path.indexOf(parsed.path) is -1
      return callback()
    if data.indexOf('startfrom') isnt -1
      return callback()
    if data.indexOf('midcom_site') isnt -1
      return callback()
    
    out.send data
    do callback
    
  c