function switch_items(category) {
  id = '#' + category + '-group';

  $('#ClosetsItems').children().remove();
  items = $(id).data('hoge');
  console.log(items);
  $.each(items, function(i, item){
    if (item.has_clothe) {
        $('#ClosetsItems').append(
                                '<div id="ClosetsItems" class="col-xs-6">' +
                                    '<div class="col-md-6 col-sm-12">' +
                                        '<div class="ItemBox" onclick="draw_image(\'' + item.category + '\', \'' + item.path + '\', '  + item.priority + ', ' + item.id + ')">' +
                                            '<img src=' + item.path +'>' +
                                        '</div></div></div>'
                            );

     } else {       //このelse文でエラー
        $('#ClosetsItems').append(
                                    '<div id="ClosetsItems" class="col-xs-6">' +
                                        '<div class="col-md-6 col-sm-12">' +
                                            '<div class="ItemBoxBg">' +
                                                '<div class="ItemBox" onclick="draw_image(\'' + item.category + '\', \'' + item.path + '\', '  + item.priority + ', ' + item.id + ')">' +
                                                    '<img src=' + item.path +'>' +
                                                    '<div class="ItemDark noto-light"></div>' +
                                                '</div></div></div></div>'
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

  $.post('/closets', users_wear ,function(data){
    console.log(data);
    location.href=user_path;
  });
}
