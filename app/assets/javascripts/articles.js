$(document).ready(function(){
  KeyEvents.ready('html','#next_page', '#previous_page');
  SocialButtons.ready('aside.socialButton');

  if ($("#new_photo").length) {
    $("#new_photo").submit(function(){
      if (!$("#photo_image").val()) {
        alert("choich photo to upload");
        return false;
      }
      $("#title_for_photo").val($("#article_title").val());
      $("#body_for_photo").val($("#article_content_attributes_body").val());
    });
  }

  if ($("#add_amazon").length) {
    $("#add_amazon").submit(function(){
      if (!$("#asin").val()) {
        alert("input asin code");
        return false;
      }
      $("#title_for_amazon").val($("#article_title").val());
      $("#body_for_amazon").val($("#article_content_attributes_body").val());
    });
  }
});

