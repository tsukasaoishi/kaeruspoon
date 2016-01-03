const loadTwitterSdk = (d, s, id) => {
  let js,fjs=d.getElementsByTagName(s)[0], p=/^http:/.test(d.location)?'http':'https';

  if(!d.getElementById(id)){
    js = d.createElement(s);
    js.id = id;
    js.src = p+'://platform.twitter.com/widgets.js';
    fjs.parentNode.insertBefore(js,fjs);
  }
};
