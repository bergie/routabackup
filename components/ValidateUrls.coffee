noflo = require 'noflo'
memento = require 'memento-client'

checkWayback = (url, callback) ->
  memento url, (err, available) ->
    return callback err, null if err
    return callback null, null unless available?.length
    last = available.filter (a) ->
      return false unless a.rel
      return false unless a.datetime
      d = new Date a.datetime
      y = d.getYear() + 1900
      return false if y > 2008
      true
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
    if photo.view
      photo.view = photo.view.replace /\/web\/[0-9*im_]+\//g, ''
    if photo.original
      photo.original = photo.original.replace /\/web\/[0-9*im_]+\//g, ''
    
      checkWayback photo.original, (err, available) ->
        photo.originalWayback = available
        unless photo.view
          out.send photo
          do callback
          return
        checkWayback photo.view, (err, available) ->
          photo.viewWayback = available
          out.send photo
          do callback
      return

    if photo.view
      checkWayback photo.view, (err, available) ->
        photo.viewWayback = available
        out.send photo
        do callback
      return
    out.send photo
    do callback
  c
