const FacebookSdk = {
  fbRoot: null,
  eventsBound: false,

  scriptLoad(d, s, id) {
    let js, fjs = d.getElementsByTagName(s)[0]
    if (d.getElementById(id)) return
    js = d.createElement(s); js.id = id
    js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.5&appId=166633613447284"
    fjs.parentNode.insertBefore(js, fjs)
  },

  bindEvents() {
    $(document)
      .on('page:fetch', this.saveRoot)
      .on('page:change', this.restoreRoot)
      .on('page:load', () => FB.XFBML.parse())
    this.fbEventsBound = true
  },

  saveRoot() {
    this.fbRoot = $('#fb-root').detach()
  },

  restoreRoot() {
    if($('#fb-root').length > 0) {
      $('#fb-root').replaceWith(this.fbRoot)
    } else {
      $('body').append(this.fbRoot)
    }
  },

  load(d, s, id) {
    this.scriptLoad(d, s, id)
    if(!this.eventBound) {
      this.bindEvents()
    }
  },

  buttonTag(url) {
    return '<div class="fb-like" data-href="' + url + '" data-layout="button_count" data-action="like" data-show-faces="true" data-share="false"></div>'
  }
}
