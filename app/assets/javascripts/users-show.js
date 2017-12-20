function users_init() {
  today = getDate();

  $('#date').val(today);
  $('#date').datepicker({
    format: "yyyy-mm-dd"
  });
}

function parse_home(text) {
  if(text){
    text = text.replace(/\s|　|\.|\,|円/g, '');
    text = text.replace(/万/g, '0000');
    text = text.replace(/千/g, '000');
    item = text.replace(/\d+/g, ' ');
    cost = text.replace(/\D+/g, ' ');
    items = item.split(' ');
    costs = cost.split(' ');
    items = $.grep(items, function(e){return e !== "";});
    costs = $.grep(costs, function(e){return e !== "";});
    for (i = 0; i < costs.length; i++){
        if (costs[i].length >= 10) {
            costs[i] = "国家予算超えちゃうよ！";
        }
    }
    $('#item-home').val(items[0]);
    $('#cost-home').val(costs[0]);
  }
}

function tweet_oauth() {
  location.href = '/auth/twitter'
}

function tweet_modal() {
  html2canvas(document.querySelector("#Charactor-Img")).then(function(canvas) {
    base64 = canvas.toDataURL('image/png');
    $('#Tweet-Modal .modal-body').children().remove();
    $('#Tweet-Modal .modal-body').append('<textarea id="tweet-text" class="form-control" rows="3" maxlength="140">私のカケイちゃんです！ | おてがる、カンタン、家計簿アプリ #家計学園</textarea>');
    $('#Tweet-Modal .modal-body').append('<img src="'+ base64 +'" style="width:80%">');
    $('#Tweet-Modal').modal('show');
  });
}

function post_tweet() {
  params = {};
  params['text'] = $('#Tweet-Modal .modal-body textarea').val();
  params['image'] = $('#Tweet-Modal .modal-body img').attr('src');
  $.post('/tweet', params ,function(){
  });
}

$(function(){
  $("#Tweet-Modal").bind('keyup' ,function(){
    $("#tweet-text").val($("#tweet-text").val());
  });
});
