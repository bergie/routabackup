noflo = require 'noflo'
cheerio = require 'cheerio'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'link'
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
    $ = cheerio.load data
    $('a').each (idx, element) ->
      $element = $ element
      out.send $element.attr 'href'
    do callback
    
  c