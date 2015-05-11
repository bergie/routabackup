noflo = require 'noflo'
path = require 'path'

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'start',
    datatype: 'boolean'
  c.outPorts.add 'url',
    datatype: 'string'
  c.outPorts.add 'filename',
    datstype: 'string'
    
  noflo.helpers.WirePattern c,
    in: 'start'
    out: ['url', 'filename']
  , (data, groups, out) ->
    last = process.argv[process.argv - 1]
    base = path.basename last
    out.filename.send "#{base}.json"
    out.url.send "http://www.routamc.org/gallery/#{base}/"
    
  c