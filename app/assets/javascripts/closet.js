function init() {

}

function draw_image(id, path) {
  id = '#' + id;
  console.log(path);
  $(id).css('background-image', 'url('+ path +')');
}
