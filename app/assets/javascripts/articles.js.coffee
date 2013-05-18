# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $("aside.socialButton").each ->
    articleId = $(@).data("articleId")
    url = "http://www.kaeruspoon.net" + Routes.article_path(articleId)

    $(@).append('<a href="http://b.hatena.ne.jp/entry/' + url + '" class="hatena-bookmark-button" data-hatena-bookmark-layout="simple-balloon" title="このエントリーをはてなブックマークに追加"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="http://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>')
    $(@).append('<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal" data-via="tsukasa_oishi" data-url="' + url + '"></a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>')
    $(@).append('<iframe src="http://www.facebook.com/plugins/like.php?href=' + url + '&amp;layout=button_count&amp;show_faces=false&amp;width=450&amp;action=like&amp;font&amp;colorscheme=light&amp;height=21" scrolling="no" frameborder="0" style="border:none; width:110px; height:21px;" allowTransparency="true"></iframe>')
    return


$(document).ready(ready)
$(document).on('page:load', ready)