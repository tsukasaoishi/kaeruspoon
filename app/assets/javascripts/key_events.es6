const KeyEvents = {
  right: 39,
  left: 37,

  ready(rootName, rightName, leftName) {
    $(rootName).keyup(e => {
      switch(e.keyCode) {
        case this.right:
          if($(rightName).length) {
            window.location.href = $(rightName).data("url")
          }
          break
        case this.left:
          if($(leftName).length) {
            window.location.href = $(leftName).data("url")
          }
          break
      }
    })
  }
}
