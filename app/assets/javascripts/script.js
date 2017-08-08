window.SpeechRecognition = window.SpeechRecognition || webkitSpeechRecognition;
var recognition = new webkitSpeechRecognition();
recognition.lang = 'ja';

// 録音終了時トリガー
recognition.addEventListener('result', function(event){
    var text = event.results.item(0).item(0).transcript;
    $("#result_text").val(text);
}, false);

recognition.onaudiostart = function() {
  $('#rec_button').html('<span class="glyphicon glyphicon-record" aria-hidden="true" style="color: #92140C;"></span> 録音中');
  $('#rec_button').prop("disabled", true);
}

recognition.onaudioend = function() {
  $('#rec_button').html('<span class="glyphicon glyphicon-record" aria-hidden="true" style="color: #92140C;"></span> 録音開始');
  $('#rec_button').prop("disabled", false);
}

function parse_input() {
  str = $("#result_text").val();

  if (str == '文字列を入力してください。') {
    return 0;
  }

  now = new Date();
  yyyymmdd = now.getFullYear()+ "-" +
	           ( "0" + ( now.getMonth()+1 ) ).slice(-2) + "-" +
	           ( "0" + now.getDate() ).slice(-2);
  id = now.getFullYear()+now.getMonth()+now.getDate()+now.getDay()+now.getMinutes()+now.getSeconds();

  if(str){
    str = str.replace(/\s|　|\.|\,|円/g, '');
    str = str.replace(/万/g, '0000');
    item = str.replace(/\d+/g, ' ');
    cost = str.replace(/\D+/g, ' ');
    items = item.split(' ');
    costs = cost.split(' ');
    items = $.grep(items, function(e){return e !== "";});
    costs = $.grep(costs, function(e){return e !== "";});
    for (i=0; i<items.length; i++) {
      $('#add_items').append('<tr>'
                            +'<td><input class="form-control" type="text" name="items[]" value="'+ items[i] +'"></td>'
                            +'<td><input class="form-control" type="text" name="costs[]" value="'+ costs[i] +'"></td>'
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

function reset() {
  $('#result_text').val('');
}

// 録音開始
function record() {
    recognition.start();
}


function remove(obj) {
    $(obj).parent().parent().remove();
    if (! $('table td').length) {
      $('#submit').hide();
    }
}

function confirm_delete() {
  $("#modal").modal('show');
}
