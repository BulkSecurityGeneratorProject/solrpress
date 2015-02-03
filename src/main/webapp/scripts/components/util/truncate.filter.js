// Generated by CoffeeScript 1.9.0
'use strict';
angular.module('solrpressApp').filter('characters', function() {
  return function(input, chars, breakOnWord) {
    var lastspace;
    lastspace = void 0;
    if (isNaN(chars)) {
      return input;
    }
    if (chars <= 0) {
      return '';
    }
    if (input && input.length > chars) {
      input = input.substring(0, chars);
      if (!breakOnWord) {
        lastspace = input.lastIndexOf(' ');
        if (lastspace !== -1) {
          input = input.substr(0, lastspace);
        }
      } else {
        while (input.charAt(input.length - 1) === ' ') {
          input = input.substr(0, input.length - 1);
        }
      }
      return input + '...';
    }
    return input;
  };
}).filter('words', function() {
  return function(input, words) {
    var inputWords;
    inputWords = void 0;
    if (isNaN(words)) {
      return input;
    }
    if (words <= 0) {
      return '';
    }
    if (input) {
      inputWords = input.split(/\s+/);
      if (inputWords.length > words) {
        input = inputWords.slice(0, words).join(' ') + '...';
      }
    }
    return input;
  };
});
