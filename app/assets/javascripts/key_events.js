var KeyEvents = {
  right: 39,
  left: 37,

  ready: function(rootName, rightName, leftName) {
    var self = this;
    $(rootName).keyup(function(e){
      switch(e.keyCode) {
        case self.right:
          if($(rightName).length) {
            window.location.href = $(rightName).data("url");
          }
          break;
        case self.left:
          if($(leftName).length) {
            window.location.href = $(leftName).data("url");
          }
          break;
      }
    })
  }
}
