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
  $('#Tweet-Modal .modal-body').children().remove();
  $('#Tweet-Modal .modal-body').append('<p>私のカケイちゃんです！ | おてがる、カンタン、家計簿アプリ #家計学園</p>');
  $('#Tweet-Modal .modal-body').append('<img src="'+ snapshot() +'">');
  $('#Tweet-Modal').modal('show');
}

function post_tweet() {
  params = {};
  params['text'] = 'テスト | おてがる、カンタン、家計簿アプリ #家計学園';
  params['image'] = $('#Tweet-Modal .modal-body img').attr('src'); 
  $.post('/tweet', params ,function(){
  });
}
