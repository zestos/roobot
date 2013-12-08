# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->

  $(".backup").click (event) ->
    event.preventDefault()

    $(".backup").removeClass("btn btn-primary btn-lg btn-block backup").addClass("btn btn-warning btn-lg btn-block backup disabled")
    $(".backup").text("Starting...")

    $.get "/backup"

    keep_checking = true

    checkStatus = ->
      $.get "/status", (data) ->
        if data["status"] == "working"
          $(".backup").text("Working...")

        if data["status"] == "failed"
          $(".backup").text("Backup Failed")
          $(".backup").removeClass("btn btn-warning btn-lg btn-block backup disabled").addClass("btn btn-danger btn-lg btn-block backup")

        if data["status"] == "complete"
          keep_checking = false
          $(".backup").text("Backup Complete!")
          $(".backup").removeClass("btn btn-warning btn-lg btn-block backup disabled").addClass("btn btn-success btn-lg btn-block backup")
        console.log data["status"]
      , "json"

    timer = setInterval ->
      if keep_checking == false
        clearInterval(timer)
      checkStatus()
    , 5000