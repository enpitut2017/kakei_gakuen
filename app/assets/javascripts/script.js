function parse_input(){
  str = $("#result_text").val();
  if(str){
    str = str.replace(/\s|　|\.|\,|円/g, '');
    str = str.replace(/万/g, '0000');
    item = str.replace(/\d+/g, ' ');
    cost = str.replace(/\D+/g, ' ');
    items = item.split(' ');
    costs = cost.split(' ');
    items = $.grep(items, function(e){return e !== "";});
    costs = $.grep(costs, function(e){return e !== "";});
    console.log(items, costs);
    for (i=0; i<items.length; i++) {
      console.log(i);
      $('#add_items').append('<input type="text" name="items[]" value="' + items[i] + '">');
      $('#add_items').append('<input type="text" name="costs[]" value="' + costs[i] + '"><br>');
    }
    $('#submit').show();
  } else {
    $('#result_text').val('文字列を入力してください。');
  }
}

window.SpeechRecognition = window.SpeechRecognition || webkitSpeechRecognition;
var recognition = new webkitSpeechRecognition();
recognition.lang = 'ja';

// 録音終了時トリガー
recognition.addEventListener('result', function(event){
    var text = event.results.item(0).item(0).transcript;
    $("#result_text").val(text);
}, false);

// 録音開始
function record()
{
    recognition.start();
}
