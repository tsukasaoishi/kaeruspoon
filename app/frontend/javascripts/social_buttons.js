import FacebookSdk from '../javascripts/facebook_sdk'

export default {
  ready(eleName) {
    $(eleName).each(function(i, ele){
      var articleId = $(ele).data("articleId");
      var url = "https://www.kaeruspoon.net/articles/" + articleId;

      FacebookSdk.load();
      $(ele).append(FacebookSdk.buttonTag(url));

      $(ele).append('<a href="http://b.hatena.ne.jp/entry/' + url + '" class="hatena-bookmark-button" data-hatena-bookmark-layout="simple-balloon" title="このエントリーをはてなブックマークに追加"><img src="https://b.st-hatena.com/images/entry-button/button-only@2x.png" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="https://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>');

      $(ele).append('<a href="https://twitter.com/share" class="twitter-share-button" data-via="tsukasa_oishi">Tweet</a><script src="//platform.twitter.com/widgets.js"></script>');

      $(ele).append('<a data-pocket-label="pocket" data-pocket-count="horizontal" class="pocket-btn" data-lang="en" data-pocket-align="right" data-save-url="' + url + '"></a><script type="text/javascript">!function(d,i){if(!d.getElementById(i)){var j=d.createElement("script");j.id=i;j.src="https://widgets.getpocket.com/v1/j/btn.js?v=1";var w=d.getElementById(i);d.body.appendChild(j);}}(document,"pocket-btn-js");</script>');
    })
  }
}
