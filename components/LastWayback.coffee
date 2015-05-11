noflo = require 'noflo'
memento = require 'memento-client'

fetchMemento = (url, callback) ->
  memento url, (err, available) ->
    return callback err if err
    last = available.filter (a) ->
      return false unless a.rel
      return false unless a.datetime
      d = new Date a.datetime
      y = d.getYear() + 1900
      return false if y > 2010
      true
    unless last.length
      if url.indexOf('html') isnt -1
        return callback new Error "No last available for #{url}"
      return fetchMemento "#{url}.html", callback
    callback null, last[last.length - 1].href

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
    fetchMemento data, (err, last) ->
      return callback err if err
      out.send last
      do callback
  c
