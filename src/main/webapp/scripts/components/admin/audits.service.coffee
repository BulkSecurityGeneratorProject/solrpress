'use strict'
angular.module('solrpressApp').factory 'AuditsService', ($http) ->
  {
    findAll: ->
      $http.get('api/audits/all').then (response) ->
        response.data
    findByDates: (fromDate, toDate) ->
      formatDate = undefined
      formatDate = undefined

      formatDate = (dateToFormat) ->
        if dateToFormat != undefined and !angular.isString(dateToFormat)
          return dateToFormat.getYear() + '-' + dateToFormat.getMonth() + '-' + dateToFormat.getDay()
        dateToFormat

      $http.get('api/audits/byDates', params:
        fromDate: formatDate(fromDate)
        toDate: formatDate(toDate)).then (response) ->
        response.data

  }
