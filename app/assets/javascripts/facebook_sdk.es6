const loadFacebookSdk = (d, s, id) => {
  let js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.5&appId=166633613447284";
  fjs.parentNode.insertBefore(js, fjs);
};

const bindFacebookEvents = () => {
  $(document)
    .on('page:fetch', saveFacebookRoot)
    .on('page:change', restoreFacebookRoot)
    .on('page:load', () => {
      FB.XFBML.parse()
    })
  window.fbEventsBound = true
}

const saveFacebookRoot = () => {
  window.fbRoot = $('#fb-root').detach()
}

const restoreFacebookRoot = () => {
  if ($('#fb-root').length > 0) {
    $('#fb-root').replaceWith(window.fbRoot)
  } else {
    $('body').append(window.fbRoot)
  }
}
