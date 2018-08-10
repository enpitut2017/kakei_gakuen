$(document).on('turbolinks:load', function() {
  $('.image_slider').slick({
    slidesToShow: 3
  });
});

function parse_input() {
  str = $("#result_text").val();

  if (str == '文字列を入力してください。') {
    return 0;
  }

  now = new Date();
  yyyymmdd = getDate();
  id = now.getFullYear()+now.getMonth()+now.getDate()+now.getDay()+now.getMinutes()+now.getSeconds();

  if(str){
    str = str.replace(/\s|　|\.|\,|円/g, '');
    str = str.replace(/万/g, '0000');
    str = str.replace(/千/g, '000');
    item = str.replace(/\d+/g, ' ');
    cost = str.replace(/\D+/g, ' ');
    items = item.split(' ');
    costs = cost.split(' ');
    items = $.grep(items, function(e){return e !== "";});
    costs = $.grep(costs, function(e){return e !== "";});
    for (i = 0; i < costs.length; i++){
        //console.log(costs[i]);
        if (costs[i].length >= 10) {
            costs[i] = "国家予算超えちゃうよ！";
        }
    }
    for (i=0; i<items.length; i++) {
      $('#add_items').append('<tr>'
                            +'<td><input class="form-control" type="text" name="items[]" value="'+ escape_html(items[i]) +'"></td>'
                            +'<td><input class="form-control" type="text" name="costs[]" value="' + escape_html(costs[i]) + '"></td>'
                            +'<td><input class="form-control" type="text" name="times[]" id="datepicker'+ id + i +'" value="' + yyyymmdd +'"></td>'
                            +'<td>　<span onClick="remove(this)" class="glyphicon glyphicon-remove" aria-hidden="true"></span></td>'
                            +'<tr>');
      $('#datepicker'+ id + i).datepicker({
        format: "yyyy-mm-dd"
      });
    }
    reset();
    $('#submit').show();
  } else {
    $('#result_text').val('文字列を入力してください。');
  }
}

function users_init() {
  today = getDate();

  $('#date').val(today);
  $('#date').datepicker({
    format: "yyyy-mm-dd"
  });
}

function reset() {
  $('#result_text').val('');
}

function getDate() {
  now = new Date();
  yyyymmdd = now.getFullYear()+ "-" +
	           ( "0" + ( now.getMonth()+1 ) ).slice(-2) + "-" +
	           ( "0" + now.getDate() ).slice(-2);

  return yyyymmdd;
}

function remove(obj) {
    $(obj).parent().parent().remove();
    if (! $('table td').length) {
      $('#submit').hide();
    }
}

function confirm_delete(modal) {
  $(modal).modal('show');
}

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

  var data = {
	  "buy_id" : bookid,
	  "user_id" : userid,
  }
  console.log(data);
  $.ajax({
	  type: "post",
	  url: "/buy_clothes",
	  data: JSON.stringify(data),
	  contentType: "application/json",
	  dataType: "json",
	  success: function(response) {
		location.reload();
		console.log(response);
	  },
	  error: function() {
		console.log("error");
	  }
  });
}

$(document).on("turbolinks:load", function() {
  $('body').tooltip({
    selector: '[data-toggle="tooltip"]'
  });
});

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
