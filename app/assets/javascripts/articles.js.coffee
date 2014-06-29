# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('html').keyup (e) ->
    switch e.which
      when 39 # Key[→]
        if($("#next_page").length)
          window.location.href = $("#next_page").data("url")
      when 37 # Key[←]
        if($("#previous_page").length)
          window.location.href = $("#previous_page").data("url")
    return

  $("aside.socialButton").each ->
    articleId = $(@).data("articleId")
    url = "http://www.kaeruspoon.net" + Routes.article_path(articleId)

    $(@).append('<iframe src="http://www.facebook.com/plugins/like.php?href=' + url + '&amp;layout=button_count&amp;show_faces=false&amp;width=450&amp;action=like&amp;font&amp;colorscheme=light&amp;height=21" scrolling="no" frameborder="0" style="border:none; width:110px; height:21px;" allowTransparency="true"></iframe>')
    $(@).append('<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal" data-via="tsukasa_oishi" data-url="' + url + '"></a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>')
    return

  if ($("#new_photo").length)
    $("#new_photo").submit ->
      if (!$("#photo_image").val())
        alert("choich photo to upload")
        return false
      $("#backup_article_title").val($("#article_title").val())
      $("#backup_article_body").val($("#article_content_attributes_body").val())
      return
    return

  if ($('#my_ad').length)
    window.MyAdSense.newAd(document.getElementById('my_ad'))

$(document).ready(ready)
