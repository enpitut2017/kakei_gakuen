function switch_items(category) {

}

function draw_image(id, path, zindex, cloth_id) {
  id = '#' + id;

  $(id).css('background-image', 'url('+ path +')');
  $(id).css('zIndex', zindex);
  $(id).children().val(cloth_id);
}

function build_json() {
  users_wear = {};

  $('.Layers').each(function(i, elm) {
    users_wear[$(elm).attr('id')] = $(elm).children().val();
  });

  console.log(users_wear);

  $.post('/closets', users_wear ,function(data){
    console.log(data);
  });
}
