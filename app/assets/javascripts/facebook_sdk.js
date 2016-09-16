var FacebookSdk = {
  fbRoot: null,
  eventsBound: false,

  myAppId: function() {
    if(window.ENV.isDevelopment) {
      return '852046904905948';
    } else {
      return '166633613447284';
    }
  },

  initializeFacebookSDK: function() {
    const myAppId = FacebookSdk.myAppId();
    return FB.init({
      appId: myAppId,
      status : true,
      cookie : true,
      xfbml: true,
      version: 'v2.5'
    })
  },

  scriptLoad: function() {
    window.fbAsyncInit = this.initializeFacebookSDK;
    $.getScript("//connect.facebook.net/ja_JP/sdk.js");
  },

  bindEvents: function() {
    $(document)
      .on('page:fetch', this.saveRoot)
      .on('page:change', this.restoreRoot)
      .on('page:load', () => FB.XFBML.parse());
    this.fbEventsBound = true
  },

  saveRoot: function() {
    if($('#fb-root').length > 0) {
      this.fbRoot = $('#fb-root').detach();
    }
  },

  restoreRoot: function() {
    if(this.fbRoot) {
      if (('#fb-root').length > 0) {
        $('#fb-root').replaceWith(this.fbRoot);
      } else {
        $('body').append(this.fbRoot);
      }
    }
  },

  load: function(d, s, id) {
    this.scriptLoad(d, s, id);
    if(!this.eventBound) {
      this.bindEvents();
    }
  },

  buttonTag: function(url) {
    return '<div class="fb-like" data-href="' + url + '" data-layout="button_count" data-action="like" data-show-faces="true" data-share="false"></div>';
  }
}
