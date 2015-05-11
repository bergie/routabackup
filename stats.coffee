photos = require './photos.json'
originals = photos.filter (p) -> p.originalWayback isnt null
views = photos.filter (p) -> p.viewWayback isnt null

console.log "#{originals.length} originals, #{views.length} views of #{photos.length}"

if originals.length
  console.log "Originals found"
  for o in originals
    console.log '', o.title, o.originalWayback
if views.length
  console.log "View-sizes found"
  for v in views
    console.log '', v.title, v.viewWayback
