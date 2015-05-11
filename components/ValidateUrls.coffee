noflo = require 'noflo'
memento = require 'memento-client'

checkWayback = (url, callback) ->
  memento url, (err, available) ->
    return callback err, null if err
    return callback null, null unless available?.length
    last = available.filter (a) -> a.rel is 'first memento'
    return callback null, null unless last.length
    callback null, last[0].href

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'in',
    datatype: 'object'
  c.outPorts.add 'out',
    datatype: 'object'
 
  noflo.helpers.WirePattern c,
    in: 'in'
    out: 'out'
    async: true
    forwardGroups: true
  , (data, groups, out, callback) ->
    photo = JSON.parse JSON.stringify data
    photo.view = photo.view.replace /\/web\/[0-9*im_]+\//g, ''
    photo.original = photo.original.replace /\/web\/[0-9*im_]+\//g, ''
    
    checkWayback photo.original, (err, available) ->
      photo.originalWayback = available
      checkWayback photo.view, (err, available) ->
        photo.viewWayback = available
        out.send photo
        do callback
 
  c