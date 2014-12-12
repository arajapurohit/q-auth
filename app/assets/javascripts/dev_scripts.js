// this will call cropper func in cropper lib to crop image
function cropImage() {
  var $modal = $("div#div_modal_generic"),
      $image = $modal.find(".modal-body-main img"),
      originalData = {};
    $modal.on("shown.bs.modal", function() {
      $image.cropper({
        aspectRatio: 1,
        minHeight: 116,
        minWidth: 116,
        data: originalData,
        done: function(data) {
          $("#image_crop_x").val(data.x);
          $("#image_crop_y").val(data.y);
          $("#image_crop_w").val(data.width);
          $("#image_crop_h").val(data.height);
        }
      });
    }).on("hidden.bs.modal", function() {
      originalData = $image.cropper("getData");
      $image.cropper("destroy");
    });
}

function cropNewImage() {
  var $modal = $("div#div_modal_generic"),
      $image = $modal.find(".modal-body-main img"),
      originalData = {};
 $image.cropper({
      aspectRatio: 1,
      minHeight: 116,
      minWidth: 116,
      data: originalData,
      done: function(data) {
        $("#image_crop_x").val(data.x);
        $("#image_crop_y").val(data.y);
        $("#image_crop_w").val(data.width);
        $("#image_crop_h").val(data.height);
      }
    });
}

function ProfilePictureupload(change_url){
  $('#user_form_photo').fileupload({
    dataType: "json",
    add: function(e, data) {
      var file, types;
      types = /(\.|\/)(gif|jpe?g|png)$/i;
      file = data.files[0];
      if (types.test(file.type) || types.test(file.name)) {
        data.context = $(tmpl("template-upload", file));
        $('#user_form_photo').append(data.context);
        if (change_url){
          data.url = '/admin/images';
        }
        data.submit();
      } else {
        return alert("" + file.name + " is not a gif, jpeg, or png image file");
      }
    },
    done: function (e, data) {
      $image = $("div#div_modal_generic").find(".modal-body-main img");
      $.each(data.result, function (index, result) {
        $("form#user_form_photo").attr("action", result.url);
        $("form#user_form_photo").attr("method", "put");
        $("form#user_form_photo img").attr("src",result.large_url).width('');
        //fix me
        // $("form#user_form_photo img").parent().removeAttr("style");
        // $("form#user_form_photo img").parent().removeAttr( "class" );
        // $("form#user_form_photo img").parent().parent().removeClass( "col-xs-4 col-md-offset-4" ).addClass( "ml-10 mr-10" );
        if ($("#image_crop_x").val()) {
          // $image.dragger.minWidth = 116;
          // $image.dragger.minHeight = 116;
          $image.cropper("setImgSrc", result.large_url);
          $image.cropper("setData", {});
        } else {
          cropNewImage();
        }
      });
    }
  });
}

//Used for Profile Pic delete
function deleteImages(){
  var $modal = $("div#div_modal_generic");
  $modal.on("hidden.bs.modal", function() {
    $.ajax({
      url: '/admin/images/destroy_pictures',
      data: 'imageable_id=' + $("#image_imageable_id").val(),
      dataType: "json",
      type: 'DELETE',
      success: function(result) {
          // Do something with the result
      }
    });
  });
}