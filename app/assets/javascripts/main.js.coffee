# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->

  $(".backup").click (event) ->
    event.preventDefault()

    $(".status").text("Backup status: starting")

    $.get "/backup"

    keep_checking = true

    checkStatus = ->
      $.get "/status", (data) ->
        if data["status"] == "complete"
          keep_checking = false
        console.log data["status"]
        $(".status").text("Backup status: " + data["status"])
      , "json"

    timer = setInterval ->
      if keep_checking == false
        clearInterval(timer)
      checkStatus()
    , 5000