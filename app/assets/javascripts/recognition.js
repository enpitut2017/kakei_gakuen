// books/new 音声入力
function record() {
  var SpeechRecognition = SpeechRecognition || webkitSpeechRecognition;
  recognition = new SpeechRecognition();
  recognition.lang = 'ja';
  recognition.start();

  // 録音終了時トリガー
  recognition.addEventListener('result', function(event){
    text = event.results[0][0].transcript;
    $("#result_text").val(text);
  }, false);

  recognition.onaudiostart = function() {
    $('#rec_button').html('<span class="glyphicon glyphicon-record" aria-hidden="true" style="color: #92140C;"></span> 入力中…');
    $('#rec_button').prop("disabled", true);
  }

  recognition.onaudioend = function() {
    $('#rec_button').html('<span class="glyphicon glyphicon-record" aria-hidden="true" style="color: #92140C;"></span> 音声入力');
    $('#rec_button').prop("disabled", false);
  }
}

// users/show 音声入力
function record_home() {
  var SpeechRecognition = SpeechRecognition || webkitSpeechRecognition;
  recognition = new SpeechRecognition();
  recognition.lang = 'ja';
  recognition.start();

  // 録音終了時トリガー
  recognition.addEventListener('result', function(event){
    text = event.results[0][0].transcript;
    parse_home(text);
  }, false);

  recognition.onaudiostart = function() {
    $('#rec_button').html('<span class="glyphicon glyphicon-record" aria-hidden="true" style="color: #92140C;"></span> 入力中…');
    $('#rec_button').prop("disabled", true);
  }

  recognition.onaudioend = function() {
    $('#rec_button').html('<span class="glyphicon glyphicon-record" aria-hidden="true" style="color: #92140C;"></span> 音声入力');
    $('#rec_button').prop("disabled", false);
  }
}
