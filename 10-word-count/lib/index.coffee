through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1
  chars = 0

  transform = (chunk, encoding, cb) ->
    
    charsA = chunk.split('')
    chars = charsA.length

    linesA = chunk.split('\n')
    console.log linesA
    lines = linesA.length-1
    if lines == 0
      lines++

    tokens = chunk.replace /([A-Z])/g, ' $1'
    tokens = tokens.match /\w+|"[^"]+"/g

    words = tokens.length
    return cb()

  flush = (cb) ->
    this.push {words, lines, chars}
    this.push null
    return cb()

  return through2.obj transform, flush