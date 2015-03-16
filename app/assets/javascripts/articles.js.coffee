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

    $(@).append('<a data-pocket-label="pocket" data-pocket-count="horizontal" class="pocket-btn" data-lang="en" data-pocket-align="right" data-save-url="' + url + '"></a><script type="text/javascript">!function(d,i){if(!d.getElementById(i)){var j=d.createElement("script");j.id=i;j.src="https://widgets.getpocket.com/v1/j/btn.js?v=1";var w=d.getElementById(i);d.body.appendChild(j);}}(document,"pocket-btn-js");</script>')
    $(@).append('<iframe src="http://www.facebook.com/plugins/like.php?href=' + url + '&amp;layout=button_count&amp;show_faces=false&amp;width=450&amp;action=like&amp;font&amp;colorscheme=light&amp;height=21" scrolling="no" frameborder="0" style="border:none; width:115px; height:21px; padding-left:5px;" allowTransparency="true"></iframe>')
    $(@).append('<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal" data-via="tsukasa_oishi" data-url="' + url + '"></a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>')
    $(@).append('<a href="http://b.hatena.ne.jp/entry/' + url + '" class="hatena-bookmark-button" data-hatena-bookmark-layout="simple-balloon" title="このエントリーをはてなブックマークに追加"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="http://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>')
    $(@).append('<span class="accessCount">' + $(@).data("articleCount") + '</span>')

    return

  if ($("#new_photo").length)
    $("#new_photo").submit ->
      if (!$("#photo_image").val())
        alert("choich photo to upload")
        return false
      $("#title_for_photo").val($("#article_title").val())
      $("#body_for_body").val($("#article_content_attributes_body").val())
      return

  if ($("#add_amazon").length)
    $("#add_amazon").submit ->
      if (!$("#asin").val())
        alert("input asin code")
        return false
      $("#title_for_amazon").val($("#article_title").val())
      $("#body_for_amazon").val($("#article_content_attributes_body").val())
      return

  if ($('#my_ad').length)
    window.MyAdSense.newAd(document.getElementById('my_ad'))

  $('#toggle_humburger').click ->
    $('#toggle_menu_list').toggle()


$(document).ready(ready)
