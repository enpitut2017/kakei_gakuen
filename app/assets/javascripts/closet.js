function switch_items(category) {
  id = '#' + category + '-group';

  $('#ClosetsItems').children().remove();
  items = $(id).data('hoge');
  $.each(items, function(i, item){
    if (item.has_clothe && item.category=="face") {
        $('#ClosetsItems').append(
                                  '<div class="col-md-6 col-sm-12">' +
                                  '<div class="ItemBox" onclick="draw_image(\'' + item.category + '\', \'' + item.path + '\', '  + item.priority + ', ' + item.id + ')">' +
                                  '<div class="ItemImg" style="background-image: url(' + item.path + ')"></div>' +
                                  '<div class="ItemImg" style="background-image: url(' + image_path("frontsilhouette.png") +'); margin-top:-148px;"></div>' +
                                  '</div></div>'
                                );
     } else if (item.category=="face") {
        $('#ClosetsItems').append(
                                  '<div class="col-md-6 col-sm-12">' +
                                  '<div class="ItemBox" onclick="confirm_clothes_purchase(\'' + item.name + '\', '  + item.user_coin + ', '  + item.price + ', ' + item.id + ', '  + item.user_id + ')">' +
                                  '<div class="ItemImg" style="background-image: url(' + item.path + ')"></div>' +
                                  '<div class="ItemImg" style="background-image: url(' + image_path("frontsilhouette.png") +'); margin-top:-148px;">' +
                                  '<div class="ItemDark"></div></div></div></div>'
                                );
     } else if (item.has_clothe) {
       $('#ClosetsItems').append(
                                 '<div class="col-md-6 col-sm-12">' +
                                 '<div class="ItemBox" onclick="draw_image(\'' + item.category + '\', \'' + item.path + '\', '  + item.priority + ', ' + item.id + ')">' +
                                 '<div class="ItemImg" style="background-image: url(' + item.path + ')"></div>' +
                                 '</div></div>'
                               );
     } else {
        $('#ClosetsItems').append(
                                  '<div class="col-md-6 col-sm-12">' +
                                  '<div class="ItemBox" onclick="confirm_clothes_purchase(\'' + item.name + '\', '  + item.user_coin + ', '  + item.price + ', ' + item.id + ', '  + item.user_id + ')">' +
                                  '<div class="ItemImg" style="background-image: url(' + item.path + ')">' +
                                  '<div class="ItemDark"></div></div></div></div>'
                                );
    }
  });
}

function draw_image(id, path, zindex, cloth_id) {
  id = '#' + id;

  $(id).css('background-image', 'url('+ path +')');
  $(id).css('zIndex', zindex);
  $(id).children().val(cloth_id);
}

function post_json(user_path) {
  users_wear = {};

  $('.Layers').each(function(i, elm) {
    users_wear[$(elm).attr('id')] = $(elm).children().val();
  });
  $.post('/closets', users_wear ,function(){
    location.href=user_path;
  });
}
