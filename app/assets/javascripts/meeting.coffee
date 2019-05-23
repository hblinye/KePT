# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    $("#toggle-user-key-block").on 'click', () ->
        $("#user-key-block").toggleClass('be-hide be-inline')
        $(".toggle-button-text").toggle()
    $("#meeting-create-button").on 'click', () ->
        $("#meeting-create-form").show()
        $("#meeting-join-form").hide()
    $("#meeting-join-button").on 'click', () ->
        $("#meeting-join-form").show()
        $("#meeting-create-form").hide()