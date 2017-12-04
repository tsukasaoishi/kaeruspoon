export default {
  myAppId() {
    if(window.ENV.isDevelopment) {
      return '852046904905948';
    } else {
      return '166633613447284';
    }
  },

  initializeFacebookSDK() {
    this.fbRoot = null;
    this.eventsBound = false;
    const myAppId = this.myAppId;
    return FB.init({
      appId: myAppId,
      status : true,
      cookie : true,
      xfbml: true,
      version: 'v2.5'
    })
  },

  scriptLoad() {
    window.fbAsyncInit = this.initializeFacebookSDK;
    $.getScript("//connect.facebook.net/ja_JP/sdk.js");
  },

  bindEvents() {
    $(document)
      .on('page:fetch', this.saveRoot)
      .on('page:change', this.restoreRoot)
      .on('page:load', function(){ FB.XFBML.parse() });
    this.fbEventsBound = true
  },

  saveRoot() {
    if($('#fb-root').length > 0) {
      this.fbRoot = $('#fb-root').detach();
    }
  },

  restoreRoot() {
    if(this.fbRoot) {
      if (('#fb-root').length > 0) {
        $('#fb-root').replaceWith(this.fbRoot);
      } else {
        $('body').append(this.fbRoot);
      }
    }
  },

  load(d, s, id) {
    this.scriptLoad(d, s, id);
    if(!this.eventBound) {
      this.bindEvents();
    }
  },

  buttonTag(url) {
    return '<div class="fb-like" data-href="' + url + '" data-layout="button_count" data-action="like" data-show-faces="true" data-share="false"></div>';
  }
}
