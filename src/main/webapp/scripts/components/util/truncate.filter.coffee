'use strict'
angular.module('solrpressApp').filter('characters', ->
  (input, chars, breakOnWord) ->
    lastspace = undefined
    if isNaN(chars)
      return input
    if chars <= 0
      return ''
    if input and input.length > chars
      input = input.substring(0, chars)
      if !breakOnWord
        lastspace = input.lastIndexOf(' ')
        if lastspace != -1
          input = input.substr(0, lastspace)
      else
        while input.charAt(input.length - 1) == ' '
          input = input.substr(0, input.length - 1)
      return input + '...'
    input
).filter 'words', ->
  (input, words) ->
    inputWords = undefined
    if isNaN(words)
      return input
    if words <= 0
      return ''
    if input
      inputWords = input.split(/\s+/)
      if inputWords.length > words
        input = inputWords.slice(0, words).join(' ') + '...'
    input
