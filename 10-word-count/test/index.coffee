assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, chars: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, chars: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, chars: 19
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!

  it 'should count quoted characters as a single again', (done) ->
    input = '"this is one word!" plus five equals six words'
    expected = words: 6, lines: 1, chars: 46
    helper input, expected, done

  it 'should split camelCased words into multiple words', (done) ->
    input = 'here are two camelCase wordsForYou'
    expected = words: 8, lines: 1, chars: 34
    helper input, expected, done

  it 'should accept file input', (done) ->
    input = fs.readFileSync './test/fixtures/1,9,44.txt', 'utf8', (data) ->
      return data
    expected = words: 9, lines: 1, chars: 44
    helper input, expected, done

  it 'should count the number of lines', (done) ->
    input = fs.readFileSync './test/fixtures/3,7,46.txt', 'utf8', (data) ->
      return data
    expected = words: 7, lines: 3, chars: 46
    helper input, expected, done

  it 'should count the number of lines again', (done) ->
    input = fs.readFileSync './test/fixtures/5,9,40.txt', 'utf8', (data) ->
      return data
    expected = words: 9, lines: 5, chars: 40
    helper input, expected, done
