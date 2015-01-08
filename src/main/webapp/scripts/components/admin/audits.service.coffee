"use strict"

angular.module("solrpressApp").factory "AuditsService", ($http) ->
    findAll: ->
        $http.get("api/audits/all").then (response) ->
            response.data


    findByDates: (fromDate, toDate) ->
        formatDate = (dateToFormat) ->
            return dateToFormat.getYear() + "-" + dateToFormat.getMonth() + "-" + dateToFormat.getDay()  if dateToFormat isnt `undefined` and not angular.isString(dateToFormat)
            dateToFormat

        $http.get("api/audits/byDates",
            params:
                fromDate: formatDate(fromDate)
                toDate: formatDate(toDate)
        ).then (response) ->
            response.data


