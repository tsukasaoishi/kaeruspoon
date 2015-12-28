$(document).ready(() => {
  $('html').keyup(e => {
    switch(e.keyCode) {
      case 39:
        if($("#next_page").length) {
          window.location.href = $("#next_page").data("url");
        }
        break;
      case 37:
        if($("#previous_page").length) {
          window.location.href = $("#previous_page").data("url");
        }
        break;
    };
  });

  $("aside.socialButton").each((i, ele) => {
    const articleId = $(ele).data("articleId");
    const url = "https://www.kaeruspoon.net" + Routes.article_path(articleId)

    $(ele).append('<a data-pocket-label="pocket" data-pocket-count="horizontal" class="pocket-btn" data-lang="en" data-pocket-align="right" data-save-url="' + url + '"></a><script type="text/javascript">!function(d,i){if(!d.getElementById(i)){var j=d.createElement("script");j.id=i;j.src="https://widgets.getpocket.com/v1/j/btn.js?v=1";var w=d.getElementById(i);d.body.appendChild(j);}}(document,"pocket-btn-js");</script>')
    $(ele).append('<div class="fb-like" data-href="' + url + '" data-layout="button_count" data-action="like" data-show-faces="true" data-share="false"></div>')
    $(ele).append('<a href="https://twitter.com/share" class="twitter-share-button"{count} data-via="tsukasa_oishi">Tweet</a>')
    $(ele).append('<a href="http://b.hatena.ne.jp/entry/' + url + '" class="hatena-bookmark-button" data-hatena-bookmark-layout="simple-balloon" title="このエントリーをはてなブックマークに追加"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="http://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>')
  });

  if ($("#new_photo").length) {
    $("#new_photo").submit(() => {
      if (!$("#photo_image").val()) {
        alert("choich photo to upload");
        return false;
      }
      $("#title_for_photo").val($("#article_title").val());
      $("#body_for_body").val($("#article_content_attributes_body").val());
    });
  }

  if ($("#add_amazon").length) {
    $("#add_amazon").submit(() => {
      if (!$("#asin").val()) {
        alert("input asin code");
        return false;
      }
      $("#title_for_amazon").val($("#article_title").val());
      $("#body_for_amazon").val($("#article_content_attributes_body").val());
    });
  }

  if ($('#my_ad').length) {
    window.MyAdSense.newAd(document.getElementById('my_ad'));
  }
});

