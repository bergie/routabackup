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
    async: true
    forwardGroups: true
  , (data, groups, out, callback) ->
    last = process.argv[process.argv.length - 1]
    base = path.basename(last) or last
    if last.indexOf('http') isnt -1
      gallery = last
    else
      gallery = "http://www.routamc.org/gallery/#{base}/"
    out.filename.send "photos/#{base}.json"
    out.url.send gallery
    do callback
  c
