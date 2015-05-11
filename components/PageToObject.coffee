noflo = require 'noflo'
cheerio = require 'cheerio'

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'in',
    datatype: 'string'
  c.outPorts.add 'out',
    datatype: 'object'
    
  noflo.helpers.WirePattern c,
    in: 'in'
    out: 'out'
    async: true
    forwardGroups: true
  , (data, groups, out, callback) ->
    val =
      title: null
      original: null
      view: null
      date: null
      
    $ = cheerio.load data
    val.title = $('h1').text()
    val.original = $('a[target="_blank"]').attr('href')
    $('img').each (idx, element) ->
      src = $(element).attr('src')
      if src.indexOf('smiley') is -1
        val.view = src
    dateLine = $('small i').text()
    if dateLine
      d = dateLine.match /([a-zA-Z\s]+)\s([0-9\s:\-]+)/
      if d
        val.date = new Date d[2]
        val.author = d[1].trim()
    out.send val
    do callback
    
  c
