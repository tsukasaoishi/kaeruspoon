(d, s, id) => {
  let js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.5&appId=166633613447284";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk');
