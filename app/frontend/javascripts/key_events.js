export default {
  ready(rootName, rightName, leftName) {
    $(rootName).keyup(function(e){
      switch(e.keyCode) {
        case 39: //right
          if($(rightName).length) {
            window.location.href = $(rightName).data("url");
          }
          break;
        case 37: //left
          if($(leftName).length) {
            window.location.href = $(leftName).data("url");
          }
          break;
      }
    })
  }
}
