function init() {

}

function draw_image(path) {
  canvas = document.getElementById('ClosetsCharactor');
  context = canvas.getContext('2d');

  image = new Image();
  image.src = path;
  image.addEventListener('load', function() {
      context.drawImage(image, 0, -10, canvas.width, canvas.height);
  }, false);
}
