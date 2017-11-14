function draw_image(id, path) {
  id = '#' + id;
  $(id).css('background-image', 'url('+ path +')');
}
