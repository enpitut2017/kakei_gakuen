function getDate() {
  now = new Date();
  yyyymmdd = now.getFullYear()+ "-" +
	           ( "0" + ( now.getMonth()+1 ) ).slice(-2) + "-" +
	           ( "0" + now.getDate() ).slice(-2);

  return yyyymmdd;
}


function confirm_delete() {
  $("#modal").modal('show');
  
function confirm_item_delete(bookid) {
  var modal_box = document.getElementById("Delete-Modal-Box");
  modal_box.innerHTML =
  '<div id="Delete-Modal" class="modal fade">' +
  '  <div class="modal-dialog">' +
  '    <div class="modal-content">' +
  '      <div class="modal-header">' +
  '        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
  '        <h3 class="modal-title">アイテム削除</h3>' +
  '      </div>' +
  '    <div class="modal-body">' +
  '      <p>アイテムを削除しますか?</p>' +
  '    </div>' +
  '    <div class="modal-footer">' +
  '       <button type="button" class="btn btn-default" data-dismiss="modal">キャンセル</button>' +
  '       <a class="btn btn-primary" rel="nofollow" data-method="delete" href="/books/' + bookid + '">削除</a>' +
  '    </div>' +
  '  </div>' +
  '</div>';
  $('#Delete-Modal').modal('show');
}

function escape_html(string) {
  if(typeof string !== 'string') {
    return string;
  }
  return string.replace(/[&'`"<>]/g, function(match) {
    return {
      '&': '&amp;',
      "'": '&#x27;',
      '`': '&#x60;',
      '"': '&quot;',
      '<': '&lt;',
      '>': '&gt;',
    }[match]
  });
}
