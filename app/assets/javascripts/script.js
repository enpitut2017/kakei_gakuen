function getDate() {
  now = new Date();
  yyyymmdd = now.getFullYear()+ "-" +
	           ( "0" + ( now.getMonth()+1 ) ).slice(-2) + "-" +
	           ( "0" + now.getDate() ).slice(-2);

  return yyyymmdd;
}

function display_modal(modal) {
  $(modal).modal('show');
}

function confirm_item_delete(bookid) {
  var modal_box = document.getElementById("Delete-Modal-Footer");
  modal_box.innerHTML =
  '<button type="button" class="btn btn-default" data-dismiss="modal">キャンセル</button>' +
  '<a class="btn btn-primary" rel="nofollow" data-method="delete" href="/books/' + bookid + '">削除</a>';
  $('#Delete-Modal').modal('show');
}

function confirm_clothes_purchase(item, coin, price, bookid, userid) {
  var pricediv = document.getElementById("Closet-Modal-Price");
  pricediv.innerHTML =
  '<p style="font-size:22px;">' + item + '</p>' +
  '<p style="font-size:20px;">カケイコイン：' +coin+' - '+price+' = '+(coin-price)+ '</p>';
  var footer = document.getElementById("Closet-Modal-Footer");
  if ((coin-price) >= 0) {
    footer.innerHTML =
    '<button type="button" class="btn btn-default" data-dismiss="modal">キャンセル</button>' +
    '<a class="btn btn-primary" rel="nofollow" onclick="buy_clothes('+bookid+','+userid+')">購入</a>';
  } else {
    footer.innerHTML =
    '<button type="button" class="btn btn-default" data-dismiss="modal">キャンセル</button>' +
    '<a class="btn btn-primary disabled" rel="nofollow">コインが足りません</a>';
  }
  $('#Closet-Modal').modal('show');
}

function buy_clothes(bookid, userid){
  var data = '{"buy_id":"' + bookid + '","user_id":"' + userid + '"}';
  console.log(data);
  $.post(
    "/buy_clothes",
    data,
    function(){},
    "json"
  )
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
