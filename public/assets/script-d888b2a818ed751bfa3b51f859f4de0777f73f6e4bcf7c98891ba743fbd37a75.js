function parse_input(){
  str = $("#result_text").val();
  if(str){
    str = str.replace(/\s|　|\.|\,|円/g, '');
    item = str.replace(/\d+/g, ' ');
    cost = str.replace(/\D+/g, ' ');
    items = item.split(' ');
    costs = cost.split(' ');
    items = $.grep(items, function(e){return e !== "";});
    costs = $.grep(costs, function(e){return e !== "";});

    //for (i=0; i<items.length; i++) {
    //  $('#add').html('<input type="text" value="' + items[i] + ' ' + costs[i] + '">');
    //}
    //$('#add').html('');
    
    $.ajax({
      type: "POST",
      url: "/books",
      data: {
        'items[]': items,
        'costs[]': costs
      }
    });
  } else {
    return $('#result_text').val('文字列を入力してください。');
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
;
